defmodule ApiWeb.CoordinateView do
  use ApiWeb, :view
  alias ApiWeb.CoordinateView

  def render("show.json", %{coordinate: coordinate}) do
    %{data: render_one(coordinate, CoordinateView, "coordinate.json")}
  end

  def render("coordinate.json", %{coordinate: coordinate}) do
    %{
      id: coordinate.id,
      ip_address: coordinate.ip_address,
      country_code: coordinate.country_code,
      country: coordinate.country,
      city: coordinate.city,
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
      mystery_value: coordinate.mystery_value
    }
  end
end
