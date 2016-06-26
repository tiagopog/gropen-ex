defmodule Gropen do
  def main([]) do
    print_error
  end

  def main(args) do
    if correct_path?(args) do
      hd(args) |> link_for |> IO.puts
    else
      print_error
    end
  end

  def link_for(path) do
    repo <> "/blob/" <> branch <> "/" <> sanitize(path)
  end

  def repo do
    System.cmd("git", ["remote", "-v"])
    |> elem(0)
    |> extract_repo_url
    |> hd
  end

  def branch do
    System.cmd("git",  ["rev-parse", "--abbrev-ref", "HEAD"])
    |> elem(0)
    |> String.strip
  end

  defp correct_path?(args) when length(args) == 0, do: false

  defp correct_path?(args) do
    path = hd(args)
    path && Regex.match?(~r/.+\.\w+(:\d+)?$/, path)
  end

  defp sanitize(path) do
    Regex.replace(~r/:(\d+)$/, path, "#L\\1")
  end

  defp extract_repo_url(srt) do
    Regex.run(~r/https?:\/\/github\.com\/\w+\/\w+/i, srt)
  end

  defp print_error do
    IO.puts "Usage: gropen PATH [OPTIONS]"
  end
end
