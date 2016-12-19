defmodule HomeBudget.SessionController do
  use HomeBudget.Web, :controller

  def new(conn, _params) do
    render conn, "new.html", current_user: nil
  end

  def create(conn, %{"session" => session_params}) do
    case HomeBudget.User.find_and_confirm_password(session_params, HomeBudget.Repo) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Logged in")
        |> redirect(to: dashboard_path(conn, :show))
      :error ->
        conn
        |> put_flash(:error, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
