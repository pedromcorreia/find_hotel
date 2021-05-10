defmodule Parser do
  @moduledoc """
  Documentation for `Parser`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Parser.hello()
      :world

  """
  def init(path) do
    path = "/Users/pedro.correia/find_hotel/apps/parser/priv/data_dump.csv"

    Parser.Workers.enqueue_job(Parser.Workers.LoadCoordinate, %{
      path: path,
      count: 0
    })
  end
end
