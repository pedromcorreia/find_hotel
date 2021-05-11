use Mix.Config

config :parser, Parser.Repo,
  username: "postgres",
  password: "postgres",
  database: "parser_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :parser, Oban,
  repo: Parser.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

config :parser, ecto_repos: [Parser.Repo]
