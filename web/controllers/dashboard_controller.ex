defmodule HomeBudget.DashboardController do
  use HomeBudget.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render conn, "show.html", current_user: user
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You have to log in")
    |> redirect(to: "/")
  end
end
