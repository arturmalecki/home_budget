defmodule HomeBudget.Account do
  use HomeBudget.Web, :model

  schema "accounts" do
    field :name, :string
    field :account_type, :string
    field :parrent_acount_id, :integer

    timestamps()

    belongs_to :project, HomeBudget.Project
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :project_id, :account_type, :parrent_acount_id])
    |> validate_required([:name, :project_id, :account_type, :parrent_acount_id])
  end
end
