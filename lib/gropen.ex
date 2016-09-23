defmodule Gropen do
  @error_message [
    usage: "Usage: gropen PATH [OPTIONS]",
    branch: "The given branch does not exist, using default \"master\""
  ]

  def main([]), do: print_error(:usage)
  def main(args) do
    args
    |> parse_args
    |> process
  end

  defp parse_args(args) do
    options = OptionParser.parse(args,
      switches: [branch: :string, commit: :string, remote: :string]
    )

    case options do
      {[help: true], _, _}   -> :help
      {options, [file|_], _} -> {options, file}
      _ -> :help
    end
  end

  def process(:help), do: print_error(:usage)
  def process({options, file}) do
    with true       <- Git.present?,
         {:ok, url} <- mount_url(file, type: :base),
         {:ok, url} <- add_branch(url, options),
         {:ok, url} <- add_file(url, file),
      do: open(url)
  end

  defp add_branch(url, options) do
    branch = cond do
      Git.remote_branch?(options[:branch]) -> options[:branch]
      true -> Git.current_branch
    end

    {:ok, url <> branch <> "/"}
  end

  defp add_file(url, file) do
    {:ok, url <> Regex.replace(~r/:(\d+)$/, file, "#L\\1")}
  end

  defp mount_url(str, options \\ []) do
    case options[:type] do
      :base -> {:ok, Git.remote_repo <> "/blob/"}
    end
  end

  defp open(url) do
    {result, _} = System.cmd("which",  ["open"])

    cond do
      String.length(result) > 0 ->
        IO.puts("Open: #{url}")
        System.cmd("open", [url])
        :ok
      true ->
        IO.puts(url)
        {:error, :no_open_cli_found}
    end
  end

  defp print_error(type) do
    IO.puts @error_message[type]
  end
end
