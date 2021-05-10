defmodule ApiWeb.CoordinateView do
  use ApiWeb, :view
  alias ApiWeb.CoordinateView

  def render("index.json", %{coordinates: coordinates}) do
    %{data: render_many(coordinates, CoordinateView, "coordinate.json")}
  end

  def render("show.json", %{coordinate: coordinate}) do
    %{data: render_one(coordinate, CoordinateView, "coordinate.json")}
  end

  def render("coordinate.json", %{coordinate: coordinate}) do
    %{id: coordinate.id}
  end
end
