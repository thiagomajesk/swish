defmodule Swish.MixProject do
  use Mix.Project

  @version "0.0.0"
  @url "https://github.com/thiagomajesk/swish"

  def project do
    [
      app: :swish,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  defp description() do
    """
    Swish is a UI toolkit for busy developers and a "no frills" replacement for the standard Phoenix 1.7 core components.
    This project aims to provide unstyled component primitives that you can use directly to speed up your development workflow.
    """
  end

  defp package do
    [
      maintainers: ["Thiago Majesk Goulart"],
      licenses: ["AGPL-3.0-only"],
      links: %{"GitHub" => @url},
      files: ~w(lib mix.exs README.md LICENSE)
    ]
  end

  defp docs() do
    [
      source_ref: "v#{@version}",
      main: "README",
      canonical: "http://hexdocs.pm/swish",
      source_url: @url,
      extras: [
        "README.md": [filename: "README"]
      ]
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
      {:gettext, "~> 0.20"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end
end
