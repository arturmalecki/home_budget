defmodule HomeBudget.RegistrationController do
  use HomeBudget.Web, :controller

  alias HomeBudget.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case HomeBudget.Registration.create(changeset, HomeBudget.Repo) do
      {:ok, changeset} ->
        conn
        |> put_flash(:info, "Your account was created!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> render("new.html", changeset: changeset)
    end
  end
end
