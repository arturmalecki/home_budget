defmodule HomeBudget.PageController do
  use HomeBudget.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
