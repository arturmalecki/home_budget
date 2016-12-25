defmodule HomeBudget.ResetPasswordService do
  import Ecto.Changeset, only: [put_change: 3]

  def create(user_changeset, repo) do
    user_changeset
    |> put_change(:reset_password_token, UUID.uuid1())
    |> repo.update()
  end
end
