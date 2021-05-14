defmodule Parser.Workers.CoordinateWorker do
  @moduledoc """
  Worker to asynchronously run Parser.Mapper with Coordinate schema.
  """

  require Logger
  use Oban.Worker, queue: :default, max_attempts: 5
  alias Parser.Schemas.Coordinate

  @doc """
  Perform asynchronously Parser.Mapper.run with giver params and Coordinate.

  ## Examples

      iex> CoordinateWorker.perform(Oban_Job)
      :ok

  """
  @spec perform(Oban.Job.t()) :: :ok
  def perform(%Oban.Job{args: %{"path" => path}}) do
    case Parser.Mapper.run(path, Coordinate) do
      {:ok, result} ->
        Logger.info("Import completed, result: #{inspect(result)}")

      _ ->
        Logger.error("Error while importing data from path")
    end

    :ok
  end
end
