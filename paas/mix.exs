defmodule MfactPaaS.MixProject do
  use Mix.Project

  @version "26.8.26"

  def project do
    [
      app: :mfact_paas,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {MfactPaaS.Application, []},
      extra_applications: [:logger, :crypto]
    ]
  end

  defp deps do
    [
      {:ash, "== 3.32.1"},
      {:ash_postgres, "== 2.12.0"},
      {:ash_r2rml,
       git: "https://github.com/seanchatmangpt/ash_r2rml.git",
       ref: "067954ad406fd637fd47646bdb10c4580809c79d"},
      {:reactor, "== 1.0.6"},
      {:jason, "~> 1.4"}
    ]
  end
end
