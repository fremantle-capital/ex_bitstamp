defmodule ExBitstamp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_bitstamp,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      name: "ExBitstamp",
      description: "Bitstamp API client for Elixir",
      source_url: "https://github.com/fremantle-capital/ex_bitstamp"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.13.0"},
      {:json,"~> 1.0"},
      {:exvcr, "~> 0.10", only: :test},
      {:credo, "~> 0.8.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.16.2", only: :dev, runtime: false},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "ExBitstamp",
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      name: :ex_bitstamp,
      maintainers: ["Alex Kwiatkowski"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/fremantle-capital/ex_bitstamp"}
    ]
  end
end
