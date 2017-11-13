defmodule SirAlex.GroupsTest do
  use SirAlex.DataCase

  alias SirAlex.{
    Accounts,
    Groups
  }
  alias SirAlex.Groups.{
    Group,
    Member
  }

  describe "groups" do
    @valid_attrs %{description: "some description", is_private: true, name: "some name"}
    @update_attrs %{description: "some updated description", is_private: false, name: "some updated name"}
    @invalid_attrs %{description: nil, is_private: nil, name: nil}

    def group_fixture(attrs \\ %{}) do
      {:ok, group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Groups.create_group()

      group
    end

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Groups.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Groups.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Groups.create_group(@valid_attrs)
      assert group.description == "some description"
      assert group.is_private == true
      assert group.name == "some name"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, group} = Groups.update_group(group, @update_attrs)
      assert %Group{} = group
      assert group.description == "some updated description"
      assert group.is_private == false
      assert group.name == "some updated name"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update_group(group, @invalid_attrs)
      assert group == Groups.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Groups.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Groups.change_group(group)
    end
  end

  describe "members" do
    @valid_attrs %{accepted_at: ~N[2010-04-17 14:00:00.000000], removed_at: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{accepted_at: ~N[2011-05-18 15:01:01.000000], removed_at: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{user_id: 0, group_id: 0}
    @user_attrs %{
      email: "some email",
      facebook_id: "some facebook_id",
      last_login: ~N[2010-04-17 14:00:00.000000],
      name: "some name"
    }

    def user_fixture() do
      {:ok, user} = Accounts.create_user(@user_attrs)
      user
    end
    def member_fixture(attrs \\ %{}) do
      group = group_fixture()
      user = user_fixture()

      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{group_id: group.id, user_id: user.id})
        |> Groups.create_member()

      member
    end

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert Groups.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Groups.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      group = group_fixture()
      user = user_fixture()
      created =
        @valid_attrs
        |> Enum.into(%{group_id: group.id, user_id: user.id})
        |> Groups.create_member

      assert {:ok, %Member{} = member} = created
      assert member.accepted_at == ~N[2010-04-17 14:00:00.000000]
      assert member.removed_at == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, member} = Groups.update_member(member, @update_attrs)
      assert %Member{} = member
      assert member.accepted_at == ~N[2011-05-18 15:01:01.000000]
      assert member.removed_at == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update_member(member, @invalid_attrs)
      assert member == Groups.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = Groups.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Groups.change_member(member)
    end
  end
end
