defmodule Swish.MixProject do
  use Mix.Project

  def project do
    [
      app: :swish,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, "~> 0.18.17"},
      {:phoenix_html, "~> 3.3.1"},
      {:gettext, "~> 0.20"}
    ]
  end
end
