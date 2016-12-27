defmodule HomeBudget.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :user_id, :integer

      timestamps()
    end

  end
end
