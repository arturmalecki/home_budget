defmodule HomeBudget.ResetPasswordServiceTest do
  import HomeBudget.Factory

  use HomeBudget.ModelCase

  describe "create/2" do
    test "creates reset_password_token" do
      user = insert(:user)
      changeset = HomeBudget.User.edit_changest(user, %{})
      assert !user.reset_password_token
      HomeBudget.ResetPasswordService.create(changeset, HomeBudget.Repo)
      assert HomeBudget.Repo.get(HomeBudget.User, user.id).reset_password_token
    end
  end
end
