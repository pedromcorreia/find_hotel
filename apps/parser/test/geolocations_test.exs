defmodule Parser.GeolocationsTest do
  use Parser.RepoCase

  alias Parser.Geolocations

  describe "coordinates" do
    alias Parser.Geolocations.Coordinate

    test "list_coordinates/0 returns all coordinates" do
      coordinate = insert(:coordinate)
      assert Geolocations.list_coordinates() == [coordinate]
    end
  end
end
