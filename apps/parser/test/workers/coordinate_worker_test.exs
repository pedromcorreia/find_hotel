defmodule Parser.Workers.CoordinateWorkerTest do
  import ExUnit.CaptureLog
  use Parser.RepoCase

  alias Parser.Workers.CoordinateWorker

  @path Path.expand("../data_dump_test.csv", __DIR__)
  use Oban.Testing, repo: Parser.Repo

  describe "Workers" do
    test "perform/1 parse data and not raise error" do
      assert :ok = perform_job(CoordinateWorker, %{path: @path})

      assert capture_log(fn ->
               perform_job(CoordinateWorker, %{path: @path, count: 0})
             end) =~ ""
    end

    test "perform/1 create job but not parse data and raise error" do
      assert :ok = perform_job(CoordinateWorker, %{path: :bad})

      assert capture_log(fn ->
               perform_job(CoordinateWorker, %{path: "path", count: 0})
             end) =~ "Error while importing data from path"
    end
  end
end
