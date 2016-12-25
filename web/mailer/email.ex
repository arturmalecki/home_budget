defmodule HomeBudget.Email do
  use Bamboo.Phoenix, view: HomeBudget.EmailView

  def password_reset_email(email_address, reset_password_url) do
    new_email
    |> to(email_address)
    |> from("support@homebudget.com")
    |> subject("Reset password")
    |> assign(:reset_password_url, reset_password_url)
    |> render(:password_reset_email)
  end
end
