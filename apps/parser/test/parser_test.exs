defmodule ParserTest do
  use Parser.RepoCase
  import ExUnit.CaptureLog

  use Oban.Testing, repo: Parser.Repo
  alias Parser.Workers.CoordinateWorker

  describe "Parser" do
    test "init/1 queue job for CoordinateWorker with parms" do
      Parser.init("path")

      assert_enqueued(worker: CoordinateWorker, args: %{path: "path", count: 0})
      assert :ok = perform_job(CoordinateWorker, %{path: "path", count: 0})
    end
  end
end
