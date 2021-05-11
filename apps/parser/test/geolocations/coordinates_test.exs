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

      refute changeset.valid?
    end

    test "with invalid latitude number" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :latitude, -91)
        )

      refute changeset.valid?

      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :latitude, 91)
        )

      refute changeset.valid?
    end

    test "with invalid longitude number" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :longitude, -181)
        )

      refute changeset.valid?

      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :longitude, 181)
        )

      refute changeset.valid?
    end

    test "with invalid country name" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :country, "Bra")
        )

      refute changeset.valid?
    end

    test "with invalid country code" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          Map.put(@valid_attrs, :country_code, "Bra")
        )

      refute changeset.valid?
    end

    test "with country name and country code different" do
      changeset =
        Coordinate.changeset(
          %Coordinate{},
          @valid_attrs
          |> Map.put(:country_code, "BR")
          |> Map.put(:country, "France")
        )

      refute changeset.valid?
    end
  end
end
