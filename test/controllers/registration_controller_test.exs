defmodule HomeBudget.RegistrationControllerTest do
  use HomeBudget.ConnCase

  test "GET /signup", _ do
    conn = build_conn()
    conn = get conn, registration_path(conn, :new)
    assert html_response(conn, 200) =~ "Register"
  end

  describe "when user is not logged in" do
    test "POST /signup with valid data" do
      conn = build_conn()
      user_params = %{"user" => %{ "email" => "a@a.a", "password" => "password", "password_confirmation" => "password" } }
      conn = post conn, registration_path(conn, :create), user_params

      assert redirected_to(conn, 302) == "/"
    end

    test "POST /signup with invalid data" do
      conn = build_conn()
      user_params = %{"user" => %{ "email" => "", "password" => "", "password_confirmation" => "password" } }
      conn = post conn, registration_path(conn, :create), user_params

      assert html_response(conn, 200)
    end
  end
end
