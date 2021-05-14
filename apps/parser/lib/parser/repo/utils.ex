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
  },Parser.Schemas.Coordinate)
  {:ok, %Parser.Schemas.Coordinate{}}
  """
  @spec insert(map(), any()) :: {:ok, map()} | {:error, map()}
  def insert(data, schema) do
    schema
    |> struct
    |> schema.changeset(data)
    |> Repo.insert()
  end

  @doc """
  Gets a single record by any params.
  Or respond with nil.

  ## Examples

  iex> get_by_params(Coordinate, %{ip_address: "38.111.125.236"})
  %Coordinate{}

  iex> get_by_params(Coordinate, %{ip_address: nil})
  nil

  """
  def get_by_params(schema, params) when is_list(params) do
    Repo.get_by(schema, params)
  end
end
