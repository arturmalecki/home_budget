defmodule HomeBudget.UserTest do
  use HomeBudget.ModelCase

  import HomeBudget.Factory

  alias HomeBudget.User
  alias HomeBudget.Repo

  @valid_attrs %{email: "some content", password: "some content"}
  @invalid_attrs %{}

  describe "changeset/2" do
    test "changeset with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "find_and_confirm_password/2" do
    test "return user if password is correct" do
      insert(:user, %{email: "jon@example.com"})

      valid_attributes = %{"email" => "jon@example.com", "password" => "password"}

      user = User.find_and_confirm_password(valid_attributes, Repo)
      assert user == {:ok, elem(user, 1)}
    end

    test "return nil if password is not correct" do
      user = User.find_and_confirm_password(%{"email" => "owen@example.com", "password" => "wrong_password"}, Repo)
      assert user == :error
    end
  end
end
