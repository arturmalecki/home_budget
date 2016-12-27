defmodule HomeBudget.Project do
  use HomeBudget.Web, :model

  schema "projects" do
    field :name, :string

    timestamps()

    belongs_to :user, HomeBudget.User
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
