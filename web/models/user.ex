defmodule HomeBudget.User do
  use HomeBudget.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end

  def find_and_confirm_password(session_params, repo) do
    user = repo.get_by(HomeBudget.User, email: String.downcase(session_params["email"]))
    case user do
      nil -> :error
      _ -> {:ok, user}
    end
  end
end
