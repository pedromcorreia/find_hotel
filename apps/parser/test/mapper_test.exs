defmodule Parser.MapperTest do
  use Parser.RepoCase

  alias Parser.Mapper
  alias Parser.Repo.Utils
  alias Parser.Schemas.Coordinate

  @path Path.expand("data_dump_test.csv", __DIR__)

  describe "Utils" do
    test "run/1 returns result with success, errors, time_elapsed" do
      assert Mapper.run(@path, Parser.Schemas.Coordinate) ==
               {:ok, %{errors: 3, success: 1, time_elapsed: 0}}

      assert Utils.get_by_params(Coordinate, ip_address: "71.95.73.73")
    end
  end
end
