defmodule HomeBudget.PasswordController do
  use HomeBudget.Web, :controller

  alias HomeBudget.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset, current_user: nil)
  end

  def create(conn, %{"password" => password_params}) do
    case Repo.get_by(HomeBudget.User, email: password_params["email"]) do
      nil ->
        changeset = User.changeset(%User{}, %{})
        render(conn, "new.html", changeset: changeset, current_user: nil)
      user ->
        user_changeset = User.edit_changest(user, %{})
        case HomeBudget.ResetPasswordService.create(user_changeset, Repo) do
          {:ok, _password} ->
            conn
            |> put_flash(:info, "Password created successfully.")
            |> redirect(to: page_path(conn, :index))
          {:error, changeset} ->
            IO.inspect changeset
            render(conn, "new.html", changeset: changeset, current_user: nil)
        end
    end
  end

  def edit(conn, %{"id" => reset_password_token}) do
    case Repo.get_by(User, reset_password_token: reset_password_token) do
      nil ->
        conn
        |> put_flash(:info, "Invalid password token")
        |> redirect(to: page_path(conn, :index))
      user ->
        changeset = User.new_password_changeset(user)
        render(conn, "edit.html", changeset: changeset, current_user: nil)
    end
  end

  def update(conn, %{"id" => reset_password_token, "password" => password_params}) do
    case Repo.get_by(User, reset_password_token: reset_password_token) do
      nil ->
        conn
        |> put_flash(:info, "Invalid password token")
        |> redirect(to: page_path(conn, :index))
      user ->
        changeset = User.new_password_changeset(user, password_params)

        case Repo.update(changeset) do
          {:ok, _user} ->
            conn
            |> put_flash(:info, "Password updated successfully.")
            |> redirect(to: page_path(conn, :index))
          {:error, changeset} ->
            render(conn, "edit.html", changeset: changeset, current_user: nil)
      end
    end
  end
end
