defmodule SirAlexWeb.MemberControllerTest do
  use SirAlexWeb.ConnCase

  alias SirAlex.Groups

  @create_attrs %{
    accepted_at: ~N[1970-01-01 00:00:00.000000],
    removed_at: ~N[1970-01-01 00:00:00.000000]
  }

  describe "index" do
    setup [:create_group]

    test "lists all members", %{conn: conn, group: group} do
      conn = get conn, member_path(conn, :index, group.id)
      assert html_response(conn, 200) =~ "Members of #{group.name}"
    end
  end

  describe "create member" do
    setup [:create_group, :create_user]

    test "redirects to show group when data is valid", %{conn: conn, group: group, user: user} do
      member_attrs = Map.merge(@create_attrs, %{group_id: group.id, user_id: user.id})
      conn =
        conn
        |> authenticate_user(user)
        |> post(member_path(conn, :create, group.id), member: member_attrs)

      assert redirected_to(conn) == group_path(conn, :show, group.id)
    end
  end

  describe "delete member" do
    setup [:create_group, :create_user]

    test "removes chosen member from the group", %{conn: conn, group: group, user: user} do
      Groups.add_member(group, user)
      conn =
        conn
        |> authenticate_user(user)
        |> delete(member_path(conn, :delete, group.id, user.id))
      assert redirected_to(conn) == member_path(conn, :index, group.id)

      conn = get conn, member_path(conn, :index, group.id)
      assert html_response(conn, 200) =~ "Successfully removed that user from the group."
    end
  end
end
