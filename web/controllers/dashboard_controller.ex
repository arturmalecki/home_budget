defmodule HomeBudget.DashboardController do
  use HomeBudget.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render conn, "show.html", user: user
  end

  def unauthenticated(conn, params) do
    conn
    |> redirect(to: "/")
  end
end
