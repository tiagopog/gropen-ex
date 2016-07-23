defmodule Gropen do
  @error_message "Usage: gropen PATH [OPTIONS]"

  def main([]), do: print_error

  def main(args) do
    {options, file, _} =
      OptionParser.parse(args,
        switches: [branch: :string, commit: :string, origin: :string]
      )
    link_for(hd(file), options)
  end

  def link_for(file, options \\ []) do
    if git? do
      # "#{repo}/blob/#{branch}/#{sanitize(file)}"
      remote_repo <> "/blob/"
      |> add_branch(options)
      |> IO.inspect
    else
      print_error
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
      if options[:branch] do
        check_branch(options[:branch])
      else
        System.cmd("git",  ["rev-parse", "--abbrev-ref", "HEAD"])
        |> elem(0)
        |> String.strip
      end
    url <> branch
  end

  def git? do
    {result, _} = System.cmd("git",  ["rev-parse", "--is-inside-work-tree"])
    String.strip(result) == "true"
  end

  defp parse_args(args) do
    file
  end

  defp check_branch(branch) do
    {result, _} = System.cmd("git", ["rev-parse", "--verify", branch])
    branch
  end

  defp sanitize(path) do
    Regex.replace(~r/:(\d+)$/, path, "#L\\1")
  end

  defp remote_repo_url(srt) do
    Regex.run(~r/https?:\/\/github\.com\/\w+\/\w+/i, srt)
  end

  defp print_error do
    IO.puts @error_message
  end
end
