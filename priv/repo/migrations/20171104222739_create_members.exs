defmodule SirAlex.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :group_id, references(:groups, on_delete: :nothing), primary_key: true
      add :user_id, references(:users, on_delete: :nothing), primary_key: true
      add :role, :string, null: false, default: "member"
      add :accepted_at, :naive_datetime, null: false, default: "epoch"
      add :removed_at, :naive_datetime, null: false, default: "epoch"

      timestamps()
    end

    create index(:members, [:group_id, :role])
    create index(:members, [:user_id, :role])
  end
end
