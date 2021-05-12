## Combine

A parser made with Elixir projects to coordinate projects.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `parser` to your list of dependencies in `mix.exs` you can add as Umbrella app using:

```elixir
def deps do
  [
    {:parser, "~> 0.1.0"}
    #or
    {:parser, in_umbrella: true}
  ]
end
```
Then
```bash
mix deps.get
```

 As Parser contains own database and has Ecto as dependency you need to create the database with:

```bash
mix do ecto.create, ecto.migrate
```
## Documentation

Parser aims to assist a web project by promoting an interface to access the database through searches by ip and with its result its stored data.

```elixir
iex> Parser.Geolocations.get_coordinate_by_ip_address("38.111.125.236")
%Parser.Geolocations.Coordinate{
  __meta__: #Ecto.Schema.Metadata<:loaded, "coordinates">,
  city: "Sethfurt",
  country: "Bahrain",
  country_code: "BH",
  id: 1,
  inserted_at: ~N[2021-05-12 16:52:00],
  ip_address: "38.111.125.236",
  latitude: -46.83383421249039,
  longitude: 175.30463608673932,
  mystery_value: "9875158070",
  updated_at: ~N[2021-05-12 16:52:00]
}
```

Also, you can populate your database using, Parser.init/1:

```elixir
iex> Parser.init
or
iex> Parser.init "path"
{:ok,
 %Oban.Job{
   __meta__: #Ecto.Schema.Metadata<:loaded, "oban_jobs">,
   args: %{count: 0, path: "/app/apps/parser/priv/data_dump.csv"},
   attempt: 0,
   attempted_at: nil,
   attempted_by: nil,
   cancelled_at: nil,
   completed_at: nil,
   conf: nil,
   discarded_at: nil,
   errors: [],
   id: 22,
   inserted_at: nil,
   max_attempts: 5,
   meta: %{},
   priority: 0,
   queue: "default",
   replace_args: nil,
   scheduled_at: ~U[2021-05-12 19:22:15.599090Z],
   state: "scheduled",
   tags: [],
   unique: nil,
   unsaved_error: nil,
   worker: "Parser.Workers.CoordinateWorker"
 }}
```

### Workers
All processes are run in the background, using [Oban](https://github.com/sorentwo/oban) to schedule their processes.

### Extensible

Parser provide a schema already configured to coordinates, but you can configure your own schema, adding it and creating a worker inside "/workers/your_schema_workers.ex" and changing the main Worker inside Parser.init.

## Roadmap

- Add custom migrations to enable a developer to create schema, worker with one command;
- Add a way to read in S3 and perform.
