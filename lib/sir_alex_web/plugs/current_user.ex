defmodule SirAlexWeb.Plugs.CurrentUser do
  alias Plug.Conn

  def get_current_user(conn, _opts) do
    case Conn.get_session(conn, :current_user) do
      nil ->
        Conn.assign(conn, :is_logged_in, false)
      user ->
        conn
        |> Conn.assign(:current_user, user)
        |> Conn.assign(:is_logged_in, true)
    end
  end
end
