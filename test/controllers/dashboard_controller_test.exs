defmodule HomeBudget.DashboardControllerTest do
  use HomeBudget.ConnCase

  import HomeBudget.Factory

  setup do
    {:ok, %{user: insert(:user)}}
  end

  describe "User is logged in" do
    test "GET /dashboard", %{user: user} do
      conn = guardian_login(user)
      |> get("/dashboard")

      assert html_response(conn, 200)
    end
  end
  
  describe "User is not logged in" do
    test "GET /dashboard", _ do
      conn = get build_conn(), "/dashboard"

      assert redirected_to(conn) == "/"
    end
  end
end
