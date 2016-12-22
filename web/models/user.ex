defmodule HomeBudget.User do
  use HomeBudget.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string
    
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    # TODO add password confirmation checker
    struct
    |> cast(params, [:email, :password, :encrypted_password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end

  def find_and_confirm_password(session_params, repo) do
    case repo.get_by(HomeBudget.User, email: String.downcase(session_params["email"])) do
      nil -> :error
      user -> check_password(user, session_params["password"])
    end
    # TODO add tests
  end

  defp check_password(user, password) do
    case Comeonin.Bcrypt.checkpw(password, user.encrypted_password) do
      true -> {:ok, user}
      _ -> :error
    end
  end
end
