defmodule Parser.Mapper.UtilsTest do
  use Parser.RepoCase

  alias Parser.Mapper.Utils
  @path Path.expand("../data_dump_test.csv", __DIR__)

  describe "Utils" do
    test "parse_csv/1 returns stream function" do
      assert is_function(Utils.parse_csv(@path))
    end

    test "parse_columns/1 returns csv columns" do
      assert Utils.parse_columns(@path) == %{
               0 => :ip_address,
               1 => :country_code,
               2 => :country,
               3 => :city,
               4 => :latitude,
               5 => :longitude,
               6 => :mystery_value
             }
    end

    test "parse_row/1 returns stream function" do
      columns = Utils.parse_columns(@path)

      row = [
        "200.106.141.15",
        "SI",
        "Nepal",
        "DuBuquemouth",
        "-84.87503094689836",
        "7.206435933364332",
        "7823011346"
      ]

      assert Utils.parse_row(row, columns) == %{
               city: "DuBuquemouth",
               country: "Nepal",
               country_code: "SI",
               ip_address: "200.106.141.15",
               latitude: "-84.87503094689836",
               longitude: "7.206435933364332",
               mystery_value: "7823011346"
             }
    end

    test "insert_row/1 create data with model and params" do
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
               Utils.insert_row(row, Parser.Geolocations.Coordinate)
    end

    test "insert_row/1 does not create data with invalid params" do
      row = %{
        city: "Curitiba",
        country: "Brazil",
        country_code: "US",
        ip_address: "200.106.141.15",
        latitude: "-84.87503094689836",
        longitude: "7.206435933364332",
        mystery_value: "7823011346"
      }

      assert {:error, _} = Utils.insert_row(row, Parser.Geolocations.Coordinate)
    end

    test "time_elapsed/1 returns time elapsed in secondes" do
      assert Utils.time_elapsed(NaiveDateTime.utc_now()) == 0
    end
  end
end
