defmodule Parser.Geolocations do
  @moduledoc """
  The Geolocations context.
  """

  import Ecto.Query, warn: false
  alias Parser.Repo

  require Logger
  alias Parser.Geolocations.Coordinate

  @doc """
  Gets a single coordinate by ip_address.
  Or respond with nil.

  ## Examples

      iex> get_coordinate_by_ip_address(123)
      %Coordinate{}

      iex> get_coordinate_by_ip_address(456)
      nil

  """

  def get_coordinate_by_ip_address(ip_address),
    do: Repo.get_by(Coordinate, ip_address: ip_address)
end
