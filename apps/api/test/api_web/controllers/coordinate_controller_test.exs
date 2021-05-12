defmodule ApiWeb.CoordinateControllerTest do
  use ApiWeb.ConnCase

  alias Parser.Geolocations.Coordinate
  alias Parser.Repo

  @valid_attrs %{
    ip_address: "68.153.157.57",
    city: "Curitiba",
    country: "Brazil",
    country_code: "BR",
    latitude: "37.968634754826695",
    longitude: "-117.84621642929545",
    mystery_value: "9648792912"
  }

  def fixture(:coordinate) do
    {:ok, coordinate} =
      %Coordinate{}
      |> Coordinate.changeset(@valid_attrs)
      |> Repo.insert()

    coordinate
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "ip_address" do
    test "get coordinates by ip_address", %{conn: conn} do
      create_coordinate()
      conn = get(conn, Routes.ip_address_path(conn, :ip_address, "68.153.157.57"))

      assert response = json_response(conn, 200)["data"]
      assert response["city"] == @valid_attrs.city
      assert response["ip_address"] == @valid_attrs.ip_address
      assert response["country"] == @valid_attrs.country
      assert response["country_code"] == @valid_attrs.country_code
      assert response["latitude"] == @valid_attrs.latitude |> String.to_float()
      assert response["longitude"] == @valid_attrs.longitude |> String.to_float()
      assert response["mystery_value"] == @valid_attrs.mystery_value
    end

    test "refute request by wrong ip_address", %{conn: conn} do
      create_coordinate()
      conn = get(conn, Routes.ip_address_path(conn, :ip_address, -1))

      assert json_response(conn, 200)["data"] ==
               nil
    end
  end

  defp create_coordinate() do
    coordinate = fixture(:coordinate)
    %{coordinate: coordinate}
  end
end
