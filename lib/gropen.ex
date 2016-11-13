defmodule Gropen do
  def process(:help), do: CLI.print_error(:usage)
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
    file = Regex.replace(~r/:(\d+)$/, file, "#L\\1")
    {:ok, url <> path <> file }
  end

  defp path do
    current_path = Path.expand(".")
    base_path    = Git.root
    if current_path == base_path, do: "", else: Path.relative_to(current_path, base_path) <> "/"
  end

  defp build_url do
    {:ok, Git.remote_repo <> "/blob/"}
  end
end
