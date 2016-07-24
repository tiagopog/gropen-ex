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
    if git? do
      remote_repo <> "/blob/"
      |> add_branch(options)
      |> add_file(file)
      |> open
    else
      print_error(:usage)
    end
  end

  def open(url) do
    if open? do
      IO.puts("Remote URL: #{url}")
      IO.puts("Opening...")
      System.cmd("open", [url])
    else
      IO.puts(url)
    end
  end

  def remote_repo do
    System.cmd("git", ["remote", "-v"])
    |> elem(0)
    |> remote_repo_url
    |> hd
  end

  def add_branch(url, options \\ []) do
    branch =
      if options[:branch] && remote_branch?(options[:branch]) do
        options[:branch]
      else
        System.cmd("git",  ["rev-parse", "--abbrev-ref", "HEAD"])
        |> elem(0)
        |> String.strip
      end
    url <> branch <> "/"
  end

  defp git? do
    {result, _} = System.cmd("git",  ["rev-parse", "--is-inside-work-tree"])
    String.strip(result) == "true"
  end

  defp open? do
    {result, _} = System.cmd("which",  ["open"])
    String.length(result) > 0
  end

  defp remote_branch?(branch) do
    {result, _} = System.cmd("git", ["ls-remote", "--heads"])
    result
    |> String.split("\n")
    |> Enum.any?(fn(remote) -> remote =~ ~r/heads\/#{branch}$/ end)
  end

  defp add_file(url, file) do
    url <> Regex.replace(~r/:(\d+)$/, file, "#L\\1")
  end

  defp remote_repo_url(srt) do
    Regex.run(~r/https?:\/\/github\.com\/\w+\/\w+/i, srt)
  end

  defp print_error(type) do
    IO.puts @error_message[type]
  end
end
