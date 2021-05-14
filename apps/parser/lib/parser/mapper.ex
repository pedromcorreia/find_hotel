defmodule Parser.Mapper do
  @moduledoc """
  This is the Parser Mapper module.
  Responsible to parse the path,
  validate data with the passing schema and save in database.
  """
  require Logger
  alias Parser.Mapper.Utils
  alias Parser.Repo.Utils, as: UtilsRepo

  @inital_result %{errors: 0, success: 0}

  @doc """
  Respond with given `path` and `schema`.

  Returns `{:ok, %(time_elapsed: 1, errors: errors 1, success: 1}`.
  Returns `{:error, :invalid_file}`.

  ## Examples

      iex> Mapper.run("path", Parser.Schemas.Coordinate)
      {:ok, %(time_elapsed: 1, errors: errors 1, success: 1}}

      iex> Mapper.run("path", InvalidSchema)
      {:ok, %(time_elapsed: 1, errors: errors 2, success: 0}}

      iex> Mapper.run("invalid_path", Parser.Schemas.Coordinate)
      {:error, :invalid_path}

  """
  @spec run(String.t(), atom()) :: {:ok, map()} | {:error, :invalid_file}
  def run(path, schema) do
    case File.exists?(path) do
      true ->
        init_timestamp = NaiveDateTime.utc_now()

        {_, result_parser} = stream_process(path, schema)
        {:ok, Map.put(result_parser, :time_elapsed, Utils.time_elapsed(init_timestamp))}

      _ ->
        {:error, :invalid_file}
    end
  end

  defp stream_process(path, schema) do
    columns = Utils.parse_columns(path)

    path
    |> Utils.parse_csv()
    |> Task.async_stream(fn row ->
      row
      |> Utils.parse_row(columns)
      |> UtilsRepo.insert(schema)
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
