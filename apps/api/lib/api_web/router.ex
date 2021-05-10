defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ApiWeb do
    pipe_through(:api)
    get("/coordinates/ip_address/:ip_address", CoordinateController, :ip_address, as: :ip_address)
  end
end
