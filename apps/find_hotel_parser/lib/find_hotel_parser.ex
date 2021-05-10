defmodule FindHotelParser do
  @moduledoc """
  Documentation for `FindHotelParser`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> FindHotelParser.hello()
      :world

  """
  def init(path) do
    path = "/Users/pedro.correia/Workspace/find_hotel_parser/priv/data_dump.csv"

    FindHotelParser.Worker.enqueue_job(FindHotelParser.Workers.LoadCoordinate, %{
      path: path,
      count: 0
    })
  end
end
