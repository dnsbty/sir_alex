defmodule SirAlexWeb.GroupControllerTest do
  use SirAlexWeb.ConnCase

  @create_attrs %{description: "some description", is_private?: true, name: "some name"}
  @update_attrs %{description: "some updated description", is_private?: false, name: "some updated name"}
  @invalid_attrs %{description: nil, is_private?: nil, name: nil}

  describe "index" do
    test "lists all groups", %{conn: conn} do
      conn = get conn, group_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Groups"
    end
  end

  describe "new group" do
    setup [:create_user]

    test "renders form", %{conn: conn, user: user} do
      conn =
        conn
        |> authenticate_user(user)
        |> get(group_path(conn, :new))
      assert html_response(conn, 200) =~ "New Group"
    end
  end

  describe "create group" do
    setup [:create_user]

    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn =
        conn
        |> authenticate_user(user)
        |> post(group_path(conn, :create), group: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == group_path(conn, :show, id)

      conn = get conn, group_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Group"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        conn
        |> authenticate_user(user)
        |> post(group_path(conn, :create), group: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Group"
    end
  end

  describe "edit group" do
    setup [:create_group, :create_user]

    test "renders form for editing chosen group", %{conn: conn, group: group, user: user} do
      create_admin(group.id, user.id)
      conn =
        conn
        |> authenticate_user(user)
        |> get(group_path(conn, :edit, group))
      assert html_response(conn, 200) =~ "Edit Group"
    end
  end

  describe "update group" do
    setup [:create_user, :create_group]

    test "redirects when data is valid", %{conn: conn, group: group, user: user} do
      create_admin(group.id, user.id)
      conn =
        conn
        |> authenticate_user(user)
        |> put(group_path(conn, :update, group), group: @update_attrs)
      assert redirected_to(conn) == group_path(conn, :show, group)

      conn = get conn, group_path(conn, :show, group)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, group: group, user: user} do
      create_admin(group.id, user.id)
      conn =
        conn
        |> authenticate_user(user)
        |> put(group_path(conn, :update, group), group: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Group"
    end
  end

  describe "delete group" do
    setup [:create_group, :create_user]

    test "deletes chosen group", %{conn: conn, group: group, user: user} do
      create_admin(group.id, user.id)
      conn =
        conn
        |> authenticate_user(user)
        |> delete(group_path(conn, :delete, group))
      assert redirected_to(conn) == group_path(conn, :index)
      conn = get conn, group_path(conn, :show, group)
      assert html_response(conn, 404) =~ "not found"
    end
  end
end
