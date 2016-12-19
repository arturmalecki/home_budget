defmodule HomeBudget.Registration do
  import Ecto.Changeset, only: [put_change: 3]

  def create(changeset, repo) do
    changeset
    |> put_change(:encrypted_password, changeset.params["passowrd"])
    |> repo.insert()
  end
end
