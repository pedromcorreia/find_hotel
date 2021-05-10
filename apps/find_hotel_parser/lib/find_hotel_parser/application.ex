defmodule FindHotelParser.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FindHotelParser.Repo,
      # Starts a worker by calling: FindHotelParser.Worker.start_link(arg)
      # {FindHotelParser.Worker, arg}
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FindHotelParser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp oban_config do
    Application.get_env(:find_hotel_parser, Oban)
  end
end
