defmodule HomeBudget.RegistrationControllerTest do
  use HomeBudget.ConnCase

  test "GET /signup", %{conn: conn} do
    conn = get conn, registration_path(conn, :new)
    assert html_response(conn, 200) =~ "Register"
  end
end
