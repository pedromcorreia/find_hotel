defmodule Parser.GeolocationsTest do
  use Parser.RepoCase

  alias Parser.Geolocations
  alias Parser.Repo.Utils

  describe "coordinates" do
    alias Parser.Geolocations.Coordinate

    @valid_attrs %{
      ip_address: "68.153.157.57",
      city: "Curitiba",
      country: "Brazil",
      country_code: "BR",
      latitude: "37.968634754826695",
      longitude: "-117.84621642929545",
      mystery_value: "9648792912"
    }

    test "get_coordinate_by_ip_address/1 returns coordinate by ip_address" do
      {:ok, coordinate} = Utils.insert(@valid_attrs, Coordinate)
      assert Geolocations.get_coordinate_by_ip_address(coordinate.ip_address) == coordinate
    end

    test "get_coordinate_by_ip_address/1 returns nil by ip_address" do
      assert Geolocations.get_coordinate_by_ip_address("invalid ip") == nil
    end
  end
end
