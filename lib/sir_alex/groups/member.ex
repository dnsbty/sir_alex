defmodule SirAlex.Groups.Member do
  use Ecto.Schema
  import Ecto.Changeset
  alias SirAlex.Accounts.User
  alias SirAlex.Groups.{
    Group,
    Member
  }

  @attrs [
    :accepted_at,
    :group_id,
    :removed_at,
    :role,
    :user_id
  ]

  @required_attrs [
    :group_id,
    :user_id
  ]

  @primary_key false
  @epoch ~N[1970-01-01 00:00:00.000000]

  schema "members" do
    field :accepted_at, :naive_datetime, default: @epoch
    field :removed_at, :naive_datetime, default: @epoch
    field :role, :string, default: "member"

    belongs_to :group, Group
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Member{} = member, attrs) do
    member
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:group_id, name: :members_pkey)
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:user_id)
  end
end
