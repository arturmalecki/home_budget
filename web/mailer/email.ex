defmodule HomeBudget.Email do
  use Bamboo.Phoenix, view: HomeBudget.EmailView

  def test_email(email_address) do
    new_email
    |> to(email_address)
    |> from("me@example.com")
    |> subject("Welcome!!!")
    |> html_body("<strong>Welcome</strong>")
    |> text_body("welcome")
  end
end
