defmodule Gropen.Mixfile do
  use Mix.Project

  def project do
    [app: :gropen,
     version: "0.1.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Gropen.CLI],
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
  end
end
