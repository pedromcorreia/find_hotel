defmodule ApiWeb.CoordinateControllerTest do
  use ApiWeb.ConnCase

  alias Api.Geolocations
  alias Api.Geolocations.Coordinate

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:coordinate) do
    {:ok, coordinate} = Geolocations.create_coordinate(@create_attrs)
    coordinate
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all coordinates", %{conn: conn} do
      conn = get(conn, Routes.coordinate_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create coordinate" do
    test "renders coordinate when data is valid", %{conn: conn} do
      conn = post(conn, Routes.coordinate_path(conn, :create), coordinate: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.coordinate_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.coordinate_path(conn, :create), coordinate: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update coordinate" do
    setup [:create_coordinate]

    test "renders coordinate when data is valid", %{conn: conn, coordinate: %Coordinate{id: id} = coordinate} do
      conn = put(conn, Routes.coordinate_path(conn, :update, coordinate), coordinate: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.coordinate_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, coordinate: coordinate} do
      conn = put(conn, Routes.coordinate_path(conn, :update, coordinate), coordinate: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete coordinate" do
    setup [:create_coordinate]

    test "deletes chosen coordinate", %{conn: conn, coordinate: coordinate} do
      conn = delete(conn, Routes.coordinate_path(conn, :delete, coordinate))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.coordinate_path(conn, :show, coordinate))
      end
    end
  end

  defp create_coordinate(_) do
    coordinate = fixture(:coordinate)
    %{coordinate: coordinate}
  end
end
