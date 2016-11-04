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
         do: {:ok, url, options}
  end

  def open({:ok, url, options}) do
    if open?(options), do: System.cmd("open", [url])
    IO.puts(url)
  end

  defp open?(options) do
    with true       <- is_nil(options[:link]),
        {result, _} <- System.cmd("which",  ["open"]),
        do: byte_size(result) > 0
  end

  defp add_branch(url, options) do
    branch = options[:branch] || Git.current_branch
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
