defmodule HomeBudget.AccountTest do
  use HomeBudget.ModelCase

  alias HomeBudget.Account

  @valid_attrs %{account_type: "some content", name: "some content", parrent_acount_id: 42, project_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end
end
