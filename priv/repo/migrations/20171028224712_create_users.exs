defmodule SirAlex.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false, default: ""
      add :email, :string, null: false
      add :facebook_id, :string, null: false

      timestamps()
    end

    create index(:users, :facebook_id, unique: true)
    create index(:users, :email, unique: true)
  end
end
