defmodule ApiTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :api_test,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ApiTest.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:poison, "~> 3.1"},
      {:cowboy, "~> 2.6"},
      {:plug_cowboy, "~> 2.0"},
      {:jsonapi, "~> 0.7.0"},
      {:joken, "~> 2.0"},
      {:timex, "~> 3.0"},
      {:amqp, "~> 2.1"},
      {:uuid, "~> 1.1"},
      {:enum_type, "~> 1.1.2"},
      {:mongodb_driver, "~> 0.7.3"},
      {:plug_crypto, "~> 1.2"},
      {:tesla, "~> 1.4.0"},
      {:hackney, "~> 1.17.0"},
      {:jason, ">= 1.0.0"}
    ]
  end
end
