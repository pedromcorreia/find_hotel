defmodule FindHotelParser.Csv.Utils do
  alias NimbleCSV.RFC4180, as: CSV

  def parse_csv(parse) do
    parse
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: true)
  end

  def parse_columns(path) do
    path
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.fetch!(0)
    |> Enum.with_index()
    |> Map.new(fn {val, num} -> {num, String.to_atom(val)} end)
  end

  def parse_row(row, column_names) do
    row
    |> Stream.with_index()
    |> Map.new(fn {val, num} -> {column_names[num], val} end)
  end
end
