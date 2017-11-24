defmodule SirAlex.Factory do
  alias SirAlex.{
    Accounts,
    Groups
  }

  @user_attrs %{email: "some email", facebook_id: "some facebook_id", last_login: ~N[2010-04-17 14:00:00.000000], name: "some name"}
  @group_attrs %{description: "some description", is_private?: true, name: "some name"}
  @member_attrs %{accepted_at: ~N[1970-01-01 00:00:00.000000], removed_at: ~N[1970-01-01 00:00:00.000000]}

  def create_group(attrs \\ %{}) do
    group = fixture(:group, attrs)
    {:ok, group: group}
  end

  def create_admin(group_id, user_id) do
    attrs = %{
      accepted_at: NaiveDateTime.utc_now(),
      group_id: group_id,
      role: "admin",
      user_id: user_id
    }
    member = fixture(:member, attrs)
    {:ok, member: member}
  end

  def create_member(%{user_id: _, group_id: _} = attrs) do
    member = fixture(:member, attrs)
    {:ok, member: member}
  end
  def create_member(attrs \\ %{}) do
    group = fixture(:group)
    user = fixture(:user)

    attrs = Enum.into(attrs, group_id: group.id, user_id: user.id)
    member = fixture(:member, attrs)
    {:ok, member: member}
  end

  def create_user(attrs \\ %{}) do
    user = fixture(:user, attrs)
    {:ok, user: user}
  end

  defp fixture(type, attrs \\ %{})
  defp fixture(:group, attrs) do
    {:ok, group} =
      attrs
      |> Enum.into(@group_attrs)
      |> Groups.create_group()
    group
  end
  defp fixture(:member, attrs) do
    {:ok, member} =
      attrs
      |> Enum.into(@member_attrs)
      |> Groups.create_member()
    member
  end
  defp fixture(:user, attrs) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_attrs)
      |> Accounts.create_user()
    user
  end
end
