defmodule Parser.Geolocations.CoordinateTest do
  use Parser.RepoCase

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

  describe "changeset/2" do
    test "valid changeset" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          @valid_attrs
        )

      assert changeset.valid?
    end

    test "with invalid ip_address" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :ip_address, nil)
        )

      assert changeset.errors == [
               ip_address: {"must be valid ip", []},
               ip_address: {"can't be blank", [validation: :required]}
             ]
    end

    test "with invalid latitude number" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :latitude, -91)
        )

      assert changeset.errors ==
               [
                 latitude:
                   {"must be greater than %{number}",
                    [{:validation, :number}, {:kind, :greater_than}, {:number, -90}]}
               ]

      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :latitude, 91)
        )

      assert changeset.errors ==
               [
                 latitude:
                   {"must be less than %{number}",
                    [{:validation, :number}, {:kind, :less_than}, {:number, 90}]}
               ]
    end

    test "with invalid longitude number" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :longitude, -181)
        )

      assert changeset.errors ==
               [
                 longitude:
                   {"must be greater than %{number}",
                    [{:validation, :number}, {:kind, :greater_than}, {:number, -180}]}
               ]

      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :longitude, 181)
        )

      assert changeset.errors ==
               [
                 longitude:
                   {"must be less than %{number}",
                    [{:validation, :number}, {:kind, :less_than}, {:number, 180}]}
               ]
    end

    test "with invalid country name" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :country, "Bra")
        )

      assert changeset.errors ==
               [country: {"the country differs from the country code", []}]
    end

    test "with invalid country code" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :country_code, "Bra")
        )

      assert changeset.errors ==
               [country: {"the country differs from the country code", []}]
    end

    test "with country name and country code different" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          @valid_attrs
          |> Map.put(:country_code, "BR")
          |> Map.put(:country, "France")
        )

      assert changeset.errors ==
               [country: {"the country differs from the country code", []}]
    end
  end
end
