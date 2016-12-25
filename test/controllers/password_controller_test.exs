defmodule HomeBudget.PasswordControllerTest do
  use HomeBudget.ConnCase

  import HomeBudget.Factory

  alias HomeBudget.User

  @valid_attrs %{email: "jon@example.com"}
  @invalid_attrs %{email: "invalid_email@example.com"}

  describe "new/2" do
    test "renders form for new resources", %{conn: conn} do
      conn = get conn, password_path(conn, :new)
      assert html_response(conn, 200) =~ "Password reset"
    end
  end

  describe "create/2" do
    test "creates resource and redirects when data is valid", %{conn: conn} do
      user = insert(:user, %{ email: "jon@example.com" })
      conn = post conn, password_path(conn, :create), password: @valid_attrs

      assert redirected_to(conn) == page_path(conn, :index)
      assert Repo.get(User, user.id).reset_password_token
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, password_path(conn, :create), password: @invalid_attrs
      assert html_response(conn, 200) =~ "Password reset"
    end
  end

  describe "edit/2" do
    test "renders form for editing chosen resource", %{conn: conn} do
      insert(:user, %{ reset_password_token: "reset_password_token" })
      conn = get conn, password_path(conn, :edit, "reset_password_token")
      assert html_response(conn, 200) =~ "Edit password reset"
    end

    test "redirect back to main page if token is invalid", %{conn: conn} do
      conn = get conn, password_path(conn, :edit, "wrong token")
      assert redirected_to(conn) == page_path(conn, :index)
    end
  end

  describe "update/2" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      user = insert(:user, %{ reset_password_token: "reset_password_token" })
      conn = put conn, password_path(conn, :update, user.reset_password_token), %{ password: %{ password: "new_password", password_confirmation: "new_password" }}
      assert redirected_to(conn) == page_path(conn, :index)
      assert HomeBudget.User.find_and_confirm_password(%{"email" =>user.email, "password" => "new_password"}, HomeBudget.Repo)
      assert !HomeBudget.Repo.get(HomeBudget.User, user.id).reset_password_token
    end

    test "does not update user password when can't find user with given token", %{conn: conn} do
      conn = put conn, password_path(conn, :update, "wrong_token"), %{ password: %{ password: "new_password", password_confirmation: "new_password" }}
      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "does not update user password when given new password is invalid", %{conn: conn} do
      user = insert(:user, %{ reset_password_token: "reset_password_token" })
      conn = put conn, password_path(conn, :update, user.reset_password_token), %{ password: %{ password: "new_password", password_confirmation: "" }}
      assert html_response(conn, 200) =~ "Edit password reset"
    end
  end
end
