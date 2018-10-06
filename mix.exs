defmodule Dobbybot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :dobbybot,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.circle": :test]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: applications(Mix.env),
      extra_applications: [:logger],
      mod: {Dobbybot.Application, []}
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:httpoison, :timex]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:timex, "~> 3.1"},
      {:joken, "~> 1.1"},
      {:httpoison, "~> 0.13"},
      {:excoveralls, "~> 0.4"},
      {:slack, "~> 0.12.0"},
      {:distillery, "~> 2.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:remix, "~> 0.0.1", only: :dev},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
