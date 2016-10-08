defmodule Gropen do
  @error_message [
    usage:  "Usage: gropen PATH [OPTIONS]",
    branch: "The given branch does not exist, using default \"master\"",
    url:    "It wasn't possible to build the remote repo URL :-("
  ]

  def main([]), do: print_error(:usage)
  def main(args) do
    args
    |> parse_args
    |> process
    |> open
  end

  def parse_args(args) do
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
         {:ok, url} <- build_url,
         {:ok, url} <- add_branch(url, options),
         {:ok, url} <- add_file(url, file),
         do: url
  end

  def open(url) when is_nil(url), do: print_error(:url)
  def open(url) do
    case System.cmd("which",  ["open"]) do
      {result, _} when byte_size(result) > 0 ->
        IO.puts("Open: #{url}")
        System.cmd("open", [url])
        {:ok}
      _ ->
        IO.puts(url)
        {:error, :no_open_cli_found}
    end
  end

  defp add_branch(url, options) do
    branch = cond do
      Git.remote_branch?(options[:branch]) -> options[:branch]
      :else                                -> Git.current_branch
    end

    {:ok, url <> branch <> "/"}
  end

  defp add_file(url, file) do
    {:ok, url <> Regex.replace(~r/:(\d+)$/, file, "#L\\1")}
  end

  defp build_url do
    {:ok, Git.remote_repo <> "/blob/"}
  end

  defp print_error(type) do
    IO.puts @error_message[type]
  end
end
