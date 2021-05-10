defmodule FindHotelParser.Geolocations do
  @moduledoc """
  The Geolocations context.
  """

  import Ecto.Query, warn: false
  alias FindHotelParser.Repo

  require Logger
  alias FindHotelParser.Geolocations.Coordinate

  @doc """
  Gets a single coordinate by ip_address.

  ## Examples

      iex> get_coordinate_by_ip_address(123)
      %Coordinate{}

      iex> get_coordinate_by_ip_address(456)
      nil

  """

  def get_coordinate_by_ip_address(ip_address),
    do: Repo.get_by(Coordinate, ip_address: ip_address)
end
