defmodule Parser.Workers.CoordinateWorker do
  require Logger
  use Oban.Worker, queue: :default, max_attempts: 5
  alias Parser.Geolocations.Coordinate

  @impl Oban.Worker
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
