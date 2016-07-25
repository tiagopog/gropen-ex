defmodule Gropen do
  @error_message [
    usage: "Usage: gropen PATH [OPTIONS]",
    branch: "The given branch does not exist, using default \"master\""
  ]

  def main([]), do: print_error(:usage)

  def main(args) do
    {options, file, _} =
      OptionParser.parse(args,
        switches: [branch: :string, commit: :string, origin: :string]
      )
    link_for(hd(file), options)
  end

  def link_for(file, options \\ []) do
    if Git.present? do
      Git.remote_repo <> "/blob/"
      |> add_branch(options)
      |> add_file(file)
      |> open
    else
      print_error(:usage)
    end
  end

  def open(url) do
    if open? do
      IO.puts("Open: #{url}")
      System.cmd("open", [url])
    else
      IO.puts(url)
    end
  end

  defp add_branch(url, options) do
    branch =
      if Git.remote_branch?(options[:branch]) do
        options[:branch]
      else
        Git.current_branch
      end
    url <> branch <> "/"
  end

  defp open? do
    {result, _} = System.cmd("which",  ["open"])
    String.length(result) > 0
  end

  defp add_file(url, file) do
    url <> Regex.replace(~r/:(\d+)$/, file, "#L\\1")
  end

  defp print_error(type) do
    IO.puts @error_message[type]
  end
end
