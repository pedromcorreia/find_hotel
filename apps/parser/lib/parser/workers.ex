defmodule Parser.Workers do
  @moduledoc """
  A Module responsible to receive some data and run the correspond worker
  """
  alias Parser.Repo
  @schedule_job_time Application.get_env(:parser, :schedule_job_time)

  def enqueue_job(worker, params = %{path: _path}, opts \\ [schedule_in: @schedule_job_time]) do
    params
    |> worker.new(opts)
    |> Repo.insert()
  end
end
