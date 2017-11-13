defmodule SirAlexWeb.MemberControllerTest do
  use SirAlexWeb.ConnCase

  alias SirAlex.{
    Accounts,
    Groups
  }

  @group_attrs %{
    description: "some description",
    is_private: false,
    name: "some name"
  }
  @user_attrs %{
    email: "some email",
    facebook_id: "some facebook_id",
    last_login: ~N[2010-04-17 14:00:00.000000],
    name: "some name"
  }

  @create_attrs %{
    accepted_at: ~N[1970-01-01 00:00:00.000000],
    removed_at: ~N[1970-01-01 00:00:00.000000]
  }
  @update_attrs %{
    accepted_at: ~N[2011-05-18 15:01:01.000000],
    removed_at: ~N[2011-05-18 15:01:01.000000]
  }
  @invalid_attrs %{
    user_id: 0,
    group_id: 0
  }

  def fixture(:group) do
    {:ok, group} = Groups.create_group(@group_attrs)
    group
  end
  def fixture(:member) do
    group = fixture(:group)
    user = fixture(:user)
    fixture(:member, user.id, group.id)
  end
  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    user
  end

  def fixture(:member, user_id, group_id) do
    attrs = Map.merge(@create_attrs, %{group_id: group_id, user_id: user_id})
    {:ok, member} = Groups.create_member(attrs)
    member
  end

  describe "index" do
    setup [:create_group]

    test "lists all members", %{conn: conn, group_id: group_id} do
      conn = get conn, member_path(conn, :index, group_id)
      assert html_response(conn, 200) =~ "Listing Members"
    end
  end

  describe "new member" do
    setup [:create_group]

    test "renders form", %{conn: conn, group_id: group_id} do
      conn = get conn, member_path(conn, :new, group_id)
      assert html_response(conn, 200) =~ "New Member"
    end
  end

  describe "create member" do
    setup [:create_group, :create_user]

    test "redirects to show when data is valid", %{conn: conn, group_id: group_id, user_id: user_id} do
      member_attrs = Map.merge(@create_attrs, %{group_id: group_id, user_id: user_id})
      conn = post conn, member_path(conn, :create, group_id), member: member_attrs

      assert %{id: member_id} = redirected_params(conn)
      assert redirected_to(conn) == member_path(conn, :show, group_id, member_id)

      conn = get conn, member_path(conn, :show, group_id, member_id)
      assert html_response(conn, 200) =~ "Show Member"
    end

    test "renders errors when data is invalid", %{conn: conn, group_id: group_id} do
      conn = post conn, member_path(conn, :create, group_id), member: @invalid_attrs
      assert html_response(conn, 200) =~ "New Member"
    end
  end

  describe "edit member" do
    setup [:create_member]

    test "renders form for editing chosen member", %{conn: conn, member: member} do
      conn = get conn, member_path(conn, :edit, member.group_id, member)
      assert html_response(conn, 200) =~ "Edit Member"
    end
  end

  describe "update member" do
    setup [:create_member]

    test "redirects when data is valid", %{conn: conn, member: member} do
      update_path = member_path(conn, :update, member.group_id, member)
      conn = put conn, update_path, member: @update_attrs
      show_path = member_path(conn, :show, member.group_id, member)
      assert redirected_to(conn) == show_path

      conn = get conn, show_path
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, member: member} do
      update_path = member_path(conn, :update, member.group_id, member)
      conn = put conn, update_path, member: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Member"
    end
  end

  describe "delete member" do
    setup [:create_member]

    test "deletes chosen member", %{conn: conn, member: member} do
      conn = delete conn, member_path(conn, :delete, member.group_id, member)
      assert redirected_to(conn) == member_path(conn, :index, member.group_id)
      assert_error_sent 404, fn ->
        get conn, member_path(conn, :show, member.group_id, member)
      end
    end
  end

  defp create_group(_) do
    group = fixture(:group)
    {:ok, group_id: group.id}
  end
  defp create_user(_) do
    user = fixture(:user)
    {:ok, user_id: user.id}
  end
  defp create_member(_) do
    member = fixture(:member)
    {:ok, member: member}
  end
end
