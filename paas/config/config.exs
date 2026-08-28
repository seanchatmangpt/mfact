import Config

config :mfact_paas,
  ash_domains: [MfactPaaS.Domain],
  ecto_repos: [MfactPaaS.Repo]

config :mfact_paas, MfactPaaS.Repo,
  username: System.get_env("MFACT_PAAS_DB_USER", "postgres"),
  password: System.get_env("MFACT_PAAS_DB_PASSWORD", "postgres"),
  hostname: System.get_env("MFACT_PAAS_DB_HOST", "localhost"),
  port: String.to_integer(System.get_env("MFACT_PAAS_DB_PORT", "5432")),
  database: System.get_env("MFACT_PAAS_DB_NAME", "mfact_paas"),
  pool_size: String.to_integer(System.get_env("MFACT_PAAS_DB_POOL_SIZE", "10"))

config :logger, level: :warning
