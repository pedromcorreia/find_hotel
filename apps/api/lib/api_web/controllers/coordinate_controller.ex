defmodule ApiWeb.CoordinateController do
  use ApiWeb, :controller

  action_fallback(ApiWeb.FallbackController)

  def ip_address(conn, %{"ip_address" => ip_address}) do
    coordinate = Parser.Geolocations.get_coordinate_by_ip_address(ip_address)
    render(conn, "show.json", coordinate: coordinate)
  end
end
