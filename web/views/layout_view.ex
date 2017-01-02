defmodule HomeBudget.LayoutView do
  use HomeBudget.Web, :view

  def menu_item_class(conn, name) do
    case {conn.private[:phoenix_controller], name} do
      {Elixir.HomeBudget.DashboardController, "dashboard"} -> "active"
      {Elixir.HomeBudget.SessionController, "login"} -> "active"
      {Elixir.HomeBudget.RegistrationController, "register"} -> "active"
      _ -> ""
    end 
  end
end
