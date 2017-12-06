defmodule Esir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :esir,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:elastix, :logger, :nimble_csv]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elastix, "~> 0.5.0"},
      {:nimble_csv, "~> 0.3"}
    ]
  end
end
