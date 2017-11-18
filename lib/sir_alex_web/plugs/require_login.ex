defmodule SirAlexWeb.Plugs.RequireLogin do
  use SirAlexWeb, :controller

  def require_login(conn, _opts) do
    case conn.assigns[:is_logged_in] do
      true -> conn
      _ ->
        conn
        |> put_flash(:info, "You need to log in before you can do that")
        |> redirect(to: auth_path(conn, :login))
        |> halt()
    end
  end
end
