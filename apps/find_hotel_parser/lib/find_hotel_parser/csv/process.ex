defmodule FindHotelParser.Csv.Process do
  require Logger
  alias NimbleCSV.RFC4180, as: CSV
  alias FindHotelParser.Csv.Utils
  alias FindHotelParser.Repo

  @inital_result %{errors: 0, success: 0}

  def init(path, model) do
    init_timestamp = NaiveDateTime.utc_now()

    {_, result_parser} = stream_process(path, model)
    {:ok, Map.put(result_parser, :time_elapsed, time_elapsed(init_timestamp))}
  end

  defp stream_process(path, model) do
    columns = Utils.parse_columns(path)

    path
    |> Utils.parse_csv()
    |> Enum.take(1000)
    |> Task.async_stream(fn row ->
      row
      |> Utils.parse_row(columns)
      |> insert_data(model)
    end)
    |> result_process()
  end

  defp result_process(stream) do
    stream
    |> Enum.map_reduce(
      @inital_result,
      fn {:ok, result}, %{errors: errors, success: success} ->
        result

        case result do
          {:error, _} ->
            {nil, %{errors: errors + 1, success: success}}

          {:ok, _} ->
            {nil, %{errors: errors, success: success + 1}}
        end
      end
    )
  end

  defp insert_data(row, model) do
    model
    |> struct
    |> model.changeset(row)
    |> Repo.insert()
  end

  defp time_elapsed(init_timestamp),
    do: NaiveDateTime.diff(NaiveDateTime.utc_now(), init_timestamp)
end
