defmodule SirAlex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SirAlex.Repo

  alias SirAlex.Accounts.User
  alias Ueberauth.Auth.Info
  alias SirAlex.Groups.{
    Group,
    Member
  }

  @epoch ~N(1970-01-01 00:00:00)

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user with group memberships attached.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      {:error, %Ecto.NoResultsError}

  """
  def get_user(user_id) do
    epoch = @epoch
    query =
      from u in User,
        left_join: m in Member,
          on: m.user_id == u.id,
          on: m.accepted_at != ^epoch,
          on: m.removed_at == ^epoch,
        left_join: g in Group,
          on: g.id == m.group_id,
        where: u.id == ^user_id,
        preload: [groups: g]

    case Repo.one(query) do
      nil -> {:error, %Ecto.NoResultsError{message: "No user found"}}
      user -> {:ok, user}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a user from Ueberauth user info.

  ## Examples

      iex> create_user(%Ueberauth.Auth.Info{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_from_auth(:facebook, facebook_id, %Info{email: email, name: name}) do
    attrs = %{
      email: email,
      facebook_id: facebook_id,
      name: name
    }
    query = from u in User, update: [set: [name: fragment("EXCLUDED.name")]]
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(conflict_target: :facebook_id, on_conflict: query, returning: true)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
