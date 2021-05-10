defmodule FindHotelParser.Repo do
  use Ecto.Repo,
    otp_app: :find_hotel_parser,
    adapter: Ecto.Adapters.Postgres
end
