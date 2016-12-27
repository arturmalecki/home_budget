defmodule HomeBudget.Factory do
  use ExMachina.Ecto, repo: HomeBudget.Repo

  alias HomeBudget.User

  def user_factory do
    %User{
      name: "Jon Owen",
      email: sequence(:email, &"email-#{&1}@example.com"),
      encrypted_password: Comeonin.Bcrypt.hashpwsalt("password")
    }
  end

  alias HomeBudget.Project

  def project_factory do
    %Project{
      name: "Home budget",
      user: build(:user)
    }
  end
end
