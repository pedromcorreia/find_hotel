defmodule Parser.Workers do
  @moduledoc """
  A Module responsible to receive some data and run the correspond worker
  """
  alias Parser.Repo

  def enqueue_job(worker, params, opts \\ []) do
    params
    |> worker.new(opts)
    |> Repo.insert()
  end
end
