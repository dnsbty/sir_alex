defmodule SirAlex.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false, default: ""
    end
  end
end
