defmodule SirAlexWeb.AuthController do
  use SirAlexWeb, :controller
  plug Ueberauth
  alias SirAlex.{
    Accounts,
    Groups
  }

  def callback(%{assigns: %{ueberauth_auth: %{info: info, provider: provider, uid: uid}}} = conn, _params) do
    with {:ok, user} <- Accounts.create_user_from_auth(provider, uid, info) do
      conn
      |> put_flash(:info, "Successfully authenticated.")
      |> put_session(:current_user, user)
      |> redirect(to: "/")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Successfully logged out.")
    |> redirect(to: "/")
  end
end
