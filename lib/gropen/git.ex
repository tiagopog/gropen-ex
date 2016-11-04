defmodule Git do
  def root do
    System.cmd("git", ["rev-parse", "--show-toplevel"])
    |> elem(0)
    |> String.strip
  end

  def present? do
    {result, _} = System.cmd("git",  ["rev-parse", "--is-inside-work-tree"])
    String.strip(result) == "true"
  end

  def remote_repo do
    System.cmd("git", ["remote", "-v"])
    |> elem(0)
    |> remote_repo_url
    |> hd
  end

  def remote_branch?(nil), do: false
  def remote_branch?(branch) do
    case System.cmd("git", ["ls-remote", "--heads"]) do
      {result, _} ->
        result
        |> String.split("\n")
        |> Enum.any?(fn(remote) -> remote =~ ~r/heads\/#{branch}$/ end)
      _ -> false
    end
  end

  def current_branch do
    System.cmd("git",  ["rev-parse", "--abbrev-ref", "HEAD"])
    |> elem(0)
    |> String.strip
  end

  defp remote_repo_url(srt) do
    Regex.run(~r/https?:\/\/github\.com\/\w+\/\w+/i, srt)
  end
end
