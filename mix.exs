defmodule Dobbybot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :dobbybot,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpoison, :timex],
      extra_applications: [:logger],
      mod: {Dobbybot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:timex, "~> 3.1"},
      {:joken, "~> 1.1"},
      {:httpoison, "~> 0.13"},
      {:dogma, "~> 0.1", only:  [:dev, :test], runtime: false},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:slack, "~> 0.12.0"}
    ]
  end
end
