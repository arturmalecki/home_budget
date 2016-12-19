defmodule HomeBudget.RegistrationTest do
  use HomeBudget.ModelCase

  alias HomeBudget.User

  test "#create should create new user if data are valid" do
    changeset = User.changeset(%User{}, %{email: "jon@example.com", password: "somepassword"})
    repo = HomeBudget.Repo
    response = HomeBudget.Registration.create(changeset, repo)

    assert response == {:ok, elem(response, 1)}
  end
end

