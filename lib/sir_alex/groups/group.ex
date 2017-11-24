defmodule SirAlex.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset
  alias SirAlex.Groups.Group

  @attrs [
    :description,
    :is_private?,
    :name,
    :deleted_at
  ]

  @required_attrs @attrs -- [
    :is_private?,
    :deleted_at
  ]

  @epoch ~N[1970-01-01 00:00:00.000000]

  schema "groups" do
    field :description, :string
    field :is_private?, :boolean, default: false
    field :name, :string
    field :member_count, :integer, virtual: true
    field :deleted_at, :naive_datetime, default: @epoch

    timestamps()
  end

  @doc false
  def changeset(%Group{} = group, attrs) do
    group
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
