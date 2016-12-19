defmodule HomeBudget.SessionControllerTest do
  use HomeBudget.ConnCase

  import HomeBudget.Factory 

  test "GET /login", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "Login"
  end

  describe "POST /loign" do
    test "Redirects to homepage with login confirmation if data are valid", _ do
      insert(:user, %{email: "jon@example.com"})
      conn = post build_conn(), "/login", %{session: %{email: "jon@example.com", password: "password"}}
      assert redirected_to(conn) == "/dashboard"
    end

    test "Renders login page with errors if data are invalid", _ do
      conn = post build_conn(), "/login", %{session: %{email: "jon@example.com", password: "password"}}
      assert html_response(conn, 200)
    end
  end
end
