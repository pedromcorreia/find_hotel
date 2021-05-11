defmodule Parser.WorkersTest do
  use Parser.RepoCase

  alias Parser.Workers.CoordinateWorker
  use Oban.Testing, repo: Parser.Repo

  describe "Workers" do
    test "enqueue_job/1 insert oban job" do
      Parser.Workers.enqueue_job(CoordinateWorker, %{
        path: "path",
        count: 0
      })

      assert_enqueued(worker: CoordinateWorker, args: %{path: "path", count: 0})
    end
  end
end
