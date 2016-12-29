defmodule HomeBudget.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string, null: false
      add :project_id, :integer, null: false
      add :account_type, :string, null: false
      add :parrent_acount_id, :integer, default: 0, null: false

      timestamps()
    end

  end
end
