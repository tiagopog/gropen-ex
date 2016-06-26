defmodule Gropen do
  def link_for(path) do
    repo <> branch <> sanitize(path)
  end

  def sanitize(path) do
    path
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
    "/master/"
  end
end
