defmodule HomeBudget.SessionControllerTest do
  use HomeBudget.ConnCase

  test "GET /login", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "Login"
  end

  describe "POST /loign" do
    test "Redirects to homepage with login confirmation if data are valid", _ do
      #conn = post conn, "/login", %{session: %{email: "jon@example.com", password: "password"}}
      #IO.puts '-------------'
      #IO.puts conn.status
      
      #response = build_conn
      #           |> post(session_path(build_conn, :create), %{session: '123'})
    end

    test "Renders login page with errors if data are invalid", _ do
    end
  end
end
