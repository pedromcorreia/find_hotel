defmodule Parser.MapperTest do
  use Parser.RepoCase

  alias Parser.Mapper
  @path Path.expand("data_dump_test.csv", __DIR__)

  describe "Utils" do
    test "run/1 returns result with success, errors, time_elapsed" do
      assert Mapper.run(@path, Parser.Geolocations.Coordinate) ==
               {:ok, %{errors: 3, success: 1, time_elapsed: 0}}

      assert Parser.Geolocations.get_coordinate_by_ip_address("71.95.73.73")
    end
  end
end
