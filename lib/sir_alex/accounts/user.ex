defmodule SirAlex.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SirAlex.Accounts.User
  alias SirAlex.Groups.{
    Group,
    Member
  }

  @attrs [
    :email,
    :facebook_id,
    :name
  ]

  schema "users" do
    field :email, :string
    field :facebook_id, :string
    field :name, :string

    many_to_many :groups, Group, join_through: Member

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
    |> unique_constraint(:email)
    |> unique_constraint(:facebook_id)
  end
end
