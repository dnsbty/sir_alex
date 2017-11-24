defmodule SirAlexWeb.UserControllerTest do
  use SirAlexWeb.ConnCase

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "Create Account"
    end
  end

  describe "show user" do
    setup [:create_user]

    test "renders page", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :show, user)
      assert html_response(conn, 200) =~ user.name
    end
  end
end
