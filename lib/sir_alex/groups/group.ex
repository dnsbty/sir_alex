defmodule SirAlex.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset
  alias SirAlex.Groups.Group

  @attrs [
    :description,
    :is_private?,
    :name
  ]

  @required_attrs @attrs -- [
    :is_private?
  ]

  schema "groups" do
    field :description, :string
    field :is_private?, :boolean, default: false
    field :name, :string
    field :member_count, :integer, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%Group{} = group, attrs) do
    group
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
