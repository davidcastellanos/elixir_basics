defmodule NewAsyncApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :new_async_app,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {NewAsyncApp.Application, []}
    ]
  end

  defp deps do
    []
  end
end