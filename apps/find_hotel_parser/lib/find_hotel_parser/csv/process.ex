defmodule FindHotelParser.Csv.Process do
  require Logger
  alias NimbleCSV.RFC4180, as: CSV
  import FindHotelParser.Csv.Utils

  @inital_result %{errors: 0, success: 0}

  def init(path, model) do
    init_timestamp = NaiveDateTime.utc_now()

    {_, result_parser} = stream_process(path, model)
    {:ok, Map.put(result_parser, :time_elapsed, time_elapsed(init_timestamp))}
  end

  defp stream_process(path, model) do
    columns = parse_columns(path)

    path
    |> parse_csv()
    |> Enum.take(1000)
    |> Task.async_stream(fn row ->
      row
      |> parse_row(columns)
      |> insert_row(model)
    end)
    |> result_process()
  end

  defp result_process(stream) do
    stream
    |> Enum.map_reduce(
      @inital_result,
      fn {:ok, result}, %{errors: errors, success: success} ->
        case result do
          {:error, _} ->
            {nil, %{errors: errors + 1, success: success}}

          {:ok, _} ->
            {nil, %{errors: errors, success: success + 1}}
        end
      end
    )
  end
end
