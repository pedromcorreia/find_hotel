import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :parser, Parser.Repo,
  ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :parser, Oban,
  repo: Parser.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

config :parser, ecto_repos: [Parser.Repo]
