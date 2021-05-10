import Config

config :find_hotel_parser, FindHotelParser.Repo,
  database: "find_hotel_parser_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :find_hotel_parser, Oban,
  repo: FindHotelParser.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

config :find_hotel_parser, ecto_repos: [FindHotelParser.Repo]
