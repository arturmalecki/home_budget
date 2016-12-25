defmodule HomeBudget.PasswordController do
  use HomeBudget.Web, :controller

  alias HomeBudget.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset, current_user: nil)
  end

  def create(conn, %{"user" => user_params}) do
    case Repo.get_by(HomeBudget.User, email: user_params["email"]) do
      nil ->
        changeset = User.changeset(%User{}, %{})
        conn
        |> put_flash(:error, "Something went wrong.")
        |> render("new.html", changeset: changeset, current_user: nil)
      user ->
        user_changeset = User.edit_changest(user, %{})
        case HomeBudget.ResetPasswordService.create(user_changeset, Repo) do
          {:ok, user} ->
            HomeBudget.Email.password_reset_email(user.email, password_url(conn, :edit, user.reset_password_token))
            |> HomeBudget.Mailer.deliver_later()
            conn
            |> put_flash(:info, "Email with password reset instructions was sent.")
            |> redirect(to: page_path(conn, :index))
          {:error, changeset} ->
            conn
            |> put_flash(:error, "Something went wrong.")
            |> render("new.html", changeset: changeset, current_user: nil)
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

  def update(conn, %{"id" => reset_password_token, "user" => user_params}) do
    case Repo.get_by(User, reset_password_token: reset_password_token) do
      nil ->
        conn
        |> put_flash(:error, "Invalid password token")
        |> redirect(to: page_path(conn, :index))
      user ->
        changeset = User.new_password_changeset(user, user_params)
                    |> User.update_password(user_params["password"])

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
