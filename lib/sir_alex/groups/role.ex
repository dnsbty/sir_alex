defmodule SirAlex.Groups.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias SirAlex.Groups.Role


  schema "roles" do
    field :name, :string
  end

  @doc false
  def changeset(%Role{} = role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
