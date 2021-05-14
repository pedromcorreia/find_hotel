defmodule Parser.Repo.UtilsTest do
  use Parser.RepoCase

  alias Parser.Repo.Utils
  alias Parser.Schemas.Coordinate

  describe "Utils" do
    @valid_attrs %{
      ip_address: "68.153.157.57",
      city: "Curitiba",
      country: "Brazil",
      country_code: "BR",
      latitude: "37.968634754826695",
      longitude: "-117.84621642929545",
      mystery_value: "9648792912"
    }

    test "insert/1 create data with model and params" do
      assert {:ok, %Coordinate{}} = Utils.insert(@valid_attrs, Coordinate)
    end

    test "insert/1 does not create data with invalid params" do
      row = %{
        city: "Curitiba",
        country: "Brazil",
        country_code: "US",
        ip_address: "200.106.141.15",
        latitude: "-84.87503094689836",
        longitude: "7.206435933364332",
        mystery_value: "7823011346"
      }

      assert {:error, _} = Utils.insert(row, Coordinate)
    end

    test "get_by_params/1 returns coordinate by ip_address" do
      {:ok, coordinate} = Utils.insert(@valid_attrs, Coordinate)
      assert Utils.get_by_params(Coordinate, ip_address: coordinate.ip_address) == coordinate
    end

    test "get_by_params/1 returns nil by ip_address" do
      assert Utils.get_by_params(Coordinate, ip_address: "invalid ip") == nil
    end
  end
end
