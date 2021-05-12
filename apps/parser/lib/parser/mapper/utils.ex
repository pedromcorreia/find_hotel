defmodule Parser.Mapper.Utils do
  @moduledoc """
  Documentation for `Parser.Mapper.Utils`.
  Module responsible to parse Csv or row data using NimbleCSV
  """

  alias NimbleCSV.RFC4180, as: CSV

  @doc """
  Documentation: parse_csv
  Receive a path respond with parse stream data.
  Response with `Stream.t()`

  ## Examples

      iex> Parser.Mapper.Utils.parse_csv("path")
      #Function<62.104660160/2 in Stream.transform/4>
  """
  @spec parse_csv(String.t()) :: any()
  def parse_csv(path) do
    path
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: true)
  end

  @doc """
  Documentation: parse_columns
  Receive a path respond with columns map.
  Response with `map`

  ## Examples

      iex> Parser.Mapper.Utils.parse_columns("path")
      %{
        0 => :ip_address,
        1 => :country_code,
        2 => :country,
        3 => :city,
        4 => :latitude,
        5 => :longitude,
        6 => :mystery_value
      }
  """
  @spec parse_columns(String.t()) :: map()
  def parse_columns(path) do
    path
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.fetch!(0)
    |> Enum.with_index()
    |> Map.new(fn {val, num} -> {num, String.to_atom(val)} end)
  end

  @doc """
  Documentation: parse_row
  Receive a row and columns map.
  Response with `map`

  ## Examples

  iex> Parser.Mapper.Utils.parse_row(
      ["200.106.141.15", "SI", "Nepal",
      "DuBuquemouth", "-84.87503094689836",
        "7.206435933364332", "7823011346"],
    columns
  )
  %{
    city: "DuBuquemouth",
    country: "Nepal",
    country_code: "SI",
    ip_address: "200.106.141.15",
    latitude: "-84.87503094689836",
    longitude: "7.206435933364332",
    mystery_value: "7823011346"
  }
  """
  @spec parse_row(list(), map()) :: map()
  def parse_row(row, column_names) do
    row
    |> Stream.with_index()
    |> Map.new(fn {val, num} -> {column_names[num], val} end)
  end

  @doc """
  Documentation: time_elapsed

  Receive a NaiveDateTime and response with difference in secods.

  ## Examples

  iex> Parser.Mapper.Utils.time_elapsed(NaiveDateTime.utc_now())
  0
  """
  @spec time_elapsed(NaiveDateTime.t()) :: integer()
  def time_elapsed(init_timestamp),
    do: NaiveDateTime.diff(NaiveDateTime.utc_now(), init_timestamp)
end
