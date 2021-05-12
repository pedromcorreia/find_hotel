defmodule Parser.Repo.UtilsTest do
  use Parser.RepoCase

  alias Parser.Repo.Utils

  describe "Utils" do
    test "insert/1 create data with model and params" do
      row = %{
        city: "Curitiba",
        country: "Brazil",
        country_code: "BR",
        ip_address: "200.106.141.15",
        latitude: "-84.87503094689836",
        longitude: "7.206435933364332",
        mystery_value: "7823011346"
      }

      assert {:ok, %Parser.Geolocations.Coordinate{}} =
               Utils.insert(row, Parser.Geolocations.Coordinate)
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

      assert {:error, _} = Utils.insert(row, Parser.Geolocations.Coordinate)
    end
  end
end
