defmodule FindHotelParser.Workers.LoadCoordinate do
  require Logger
  use Oban.Worker, queue: :default, max_attempts: 5
  alias FindHotelParser.Geolocations.Coordinate

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"path" => path}}) do
    case FindHotelParser.Csv.Process.init(path, Coordinate) do
      {:ok, result} ->
        Logger.info("Import completed, result: #{inspect(result)}")

      _ ->
        Logger.info("Error while importing data from path")
    end

    :ok
  end
end
