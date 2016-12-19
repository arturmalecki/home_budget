defmodule HomeBudget.PageController do
  use HomeBudget.Web, :controller

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render conn, "index.html", current_user: user
  end
end
