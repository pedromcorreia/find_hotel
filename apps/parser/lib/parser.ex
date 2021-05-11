defmodule Parser do
  @moduledoc """
  Documentation for `Parser`.
  """
  @path "/Users/pedro.correia/find_hotel/apps/parser/priv/data_dump.csv"

  @doc """
  Hello world.

  ## Examples

      iex> Parser.hello()
      :world

  """
  def init(path \\ @path) do
    Parser.Workers.enqueue_job(Parser.Workers.CoordinateWorker, %{
      path: path,
      count: 0
    })
  end
end
