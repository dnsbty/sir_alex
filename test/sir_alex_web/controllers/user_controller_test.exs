defmodule SirAlexWeb.UserControllerTest do
  use SirAlexWeb.ConnCase

  alias SirAlex.Accounts

  @create_attrs %{email: "some email", facebook_id: "some facebook_id", last_login: ~N[2010-04-17 14:00:00.000000], name: "some name"}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "Create Account"
    end
  end

  describe "show user" do
    test "renders page", %{conn: conn} do
      {:ok, user: user} = create_user(nil)
      conn = get conn, user_path(conn, :show, user.id, [])
      assert html_response(conn, 200) =~ user.name
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
