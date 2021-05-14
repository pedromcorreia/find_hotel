defmodule ApiWeb.CoordinateController do
  use ApiWeb, :controller

  action_fallback(ApiWeb.FallbackController)
  alias Parser.Repo.Utils
  alias Parser.Schemas.Coordinate

  def ip_address(conn, %{"ip_address" => ip_address}) do
    coordinate = Utils.get_by_params(Coordinate, ip_address: ip_address)
    render(conn, "show.json", coordinate: coordinate)
  end
end
