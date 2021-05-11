import Config

config :parser, Parser.Repo,
  database: "parser",
  username: "postgres",
  password: "postgres",
  hostname: "db"

config :parser, Oban,
  repo: Parser.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

config :parser, ecto_repos: [Parser.Repo]
