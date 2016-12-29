defmodule HomeBudget.User do
  use HomeBudget.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string
    field :reset_password_token, :string
    
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :projects, HomeBudget.Project

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :encrypted_password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_password
  end

  def edit_changest(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :encrypted_password])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  def new_password_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password])
    |> validate_password
    |> put_change(:reset_password_token, nil)
  end

  def update_password(struct, password) do
    struct
    |> put_change(:encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
  end

  def find_and_confirm_password(session_params, repo) do
    case repo.get_by(HomeBudget.User, email: String.downcase(session_params["email"])) do
      nil -> :error
      user -> check_password(user, session_params["password"])
    end
  end

  defp check_password(user, password) do
    case Comeonin.Bcrypt.checkpw(password, user.encrypted_password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp validate_password(struct) do
    struct
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 8)
  end
end
