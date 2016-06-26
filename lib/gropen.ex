defmodule Gropen do
  def for(path) do
    repo <> branch <> sanitize(path)
  end

  def sanitize(path) do
    Regex.replace(~r/:(\d+)$/, path, "#L\\1")
  end

  def repo do
    System.cmd("git", ["remote", "-v"])
    |> elem(0)
    |> extract_repo_url
    |> hd
  end

  def extract_repo_url(srt) do
    Regex.run(~r/https?:\/\/github\.com\/\w+\/\w+/i, srt)
  end

  def branch do
    branch_name =
      System.cmd("git",  ["rev-parse", "--abbrev-ref", "HEAD"])
      |> elem(0)
      |> String.strip
    "/" <> branch_name <> "/"
  end
end
