defmodule Gropen.CLI do
  @error_message [
    usage:  "Usage: gropen PATH [OPTIONS]",
    branch: "The given branch does not exist, using default \"master\"",
    url:    "It wasn't possible to build the remote repo URL :-("
  ]

  def main([]), do: print_error(:usage)
  def main(args) do
    args
    |> parse_args
    |> Gropen.process
    |> Gropen.open

  end

  def parse_args(args) do
    options = OptionParser.parse(args,
      switches: [branch: :string, commit: :string, remote: :string],
      aliases: [b: :branch, l: :link]
    )

    case options do
      {[help: true], _, _}   -> :help
      {options, [file|_], _} -> {options, file}
      _ -> :help
    end
  end

  defp print_error(type) do
    IO.puts @error_message[type]
  end
end
