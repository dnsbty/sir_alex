defmodule SirAlex.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  alias SirAlex.Repo

  alias SirAlex.Groups.{
    Group,
    Member
  }

  @epoch ~N[1970-01-01 00:00:00]

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  ## Examples

      iex> get_group(123)
      {:ok, %Group{}}

      iex> get_group(456)
      {:error, Ecto.NoResultsError{})

  """
  def get_group(id), do: Repo.get(Group, id)

  @doc """
  Gets a single group and a user's membership relationship with it.

  ## Examples

      iex> get_group_and_membership(123, 456)
      {:ok, %{group: %Group{}, is_member?: true, is_admin?: false}}

      iex> get_group_and_membership(456, 789)
      {:error, Ecto.NoResultsError{})

  """
  def get_group_and_membership(group_id, user_id) do
    epoch = @epoch
    query =
      from g in Group,
        left_join: m in Member,
          on: g.id == m.group_id,
          on: m.user_id == ^user_id,
          on: m.removed_at == ^epoch,
        where: g.id == ^group_id,
        select: {g, m.role}

    case Repo.one(query) do
      {group, nil} -> {:ok, %{group: group, is_member?: false, is_admin?: false}}
      {group, "member"} -> {:ok, %{group: group, is_member?: true, is_admin?: false}}
      {group, "admin"} -> {:ok, %{group: group, is_member?: true, is_admin?: true}}
      _ -> {:error, %Ecto.NoResultsError{message: "Group not found"}}
    end
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{source: %Group{}}

  """
  def change_group(%Group{} = group) do
    Group.changeset(group, %{})
  end

  @doc """
  Returns the list of members.

  ## Examples

      iex> list_members()
      [%Member{}, ...]

  """
  def list_members do
    Repo.all(Member)
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id), do: Repo.get!(Member, id)

  @doc """
  Adds a user as a member of a group.

  ## Examples

      iex> add_member(%Group{}, %User{})
      {:ok, %Member{}}

      iex> add_member(nil, nil)
      {:error, %Ecto.Changeset{}}

  """
  def add_member(group, user) do
    epoch = @epoch
    accepted_at = case group.is_private? do
      true -> epoch
      _ -> NaiveDateTime.utc_now()
    end

    attrs = %{
      group_id: group.id,
      user_id: user.id,
      accepted_at: accepted_at
    }

    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert(conflict_target: [:group_id, :user_id], on_conflict: [set: [removed_at: epoch]])
  end

  @doc """
  Creates a member.

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  @doc """
  Removes a Member from a Group.

  ## Examples

      iex> remove_member(member)
      {:ok, %Member{}}

      iex> remove_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def remove_member(group_id, user_id) do
    epoch = @epoch
    query =
      from m in Member,
        where: m.group_id == ^group_id,
        where: m.user_id == ^user_id,
        where: m.removed_at == ^epoch,
        update: [set: [removed_at: ^NaiveDateTime.utc_now()]]
    Repo.update_all(query, []) |> IO.inspect
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{source: %Member{}}

  """
  def change_member(%Member{} = member) do
    Member.changeset(member, %{})
  end

  @doc """
  Returns a list of groups to which a user belongs.

  ## Examples

    iex> list_user_groups(123)
    [%Group{}]

    iex> list_user_groups(456)
    []
  """
  def list_user_groups(user_id) do
    epoch = @epoch
    query =
      from g in Group,
        join: m in Member, on: g.id == m.group_id,
        select: {g.id, g.name, m.role},
        where: m.user_id == ^user_id,
        where: m.accepted_at != ^epoch,
        where: m.removed_at == ^epoch
    Repo.all(query) |> IO.inspect
  end
end
