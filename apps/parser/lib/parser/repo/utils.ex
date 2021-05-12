defmodule Parser.Repo.Utils do
  alias Parser.Repo

  @moduledoc """
  Documentation for `Parser.Repo.Utils`.
  Module responsible help with repo data.
  """

  @doc """
  Documentation: insert

  Receive a row and struct, then insert in struct table.
  Response with `{:ok, struct}` or  `{:error, struct}`

  ## Examples

  iex> Parser.Repo.Utils.insert(%{
    city: "DuBuquemouth",
    country: "Nepal",
    country_code: "SI",
    ip_address: "200.106.141.15",
    latitude: "-84.87503094689836",
    longitude: "7.206435933364332",
    mystery_value: "7823011346"
  },Parser.Geolocations.Coordinate)
  {:ok, %Parser.Geolocations.Coordinate{}}
  """
  @spec insert(map(), any()) :: {:ok, map()} | {:error, map()}
  def insert(data, model) do
    model
    |> struct
    |> model.changeset(data)
    |> Repo.insert()
  end
end
