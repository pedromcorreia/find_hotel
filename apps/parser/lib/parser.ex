defmodule Parser do
  @moduledoc """
  Documentation for `Parser`.
  Create new job to parse data and load in database.
  """
  @path Path.expand("apps/parser/priv/data_dump.csv", __DIR__)

  @doc """
  Receive a path, create a job to perform async with oban.
  If nothing is passed will perfom with `@path`
  Response with `{:ok, %Oban{}}`

  ## Examples

      iex> Parser.init()
      {:ok, %Oban{}}

      iex> Parser.init("path.csv")
      {:ok, %Oban{}}

  """
  @spec init(String.t()) :: {:ok, map()}
  def init(path \\ @path) do
    Parser.Workers.enqueue_job(Parser.Workers.CoordinateWorker, %{
      path: path,
      count: 0
    })
  end
end
