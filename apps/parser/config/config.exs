import Config

config :parser, Parser.Repo,
  database: "parser_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :parser, Oban,
  repo: Parser.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

config :parser, ecto_repos: [Parser.Repo]
