defmodule SirAlexWeb.AuthHelper do
  import Plug.Test

  def authenticate_user(conn, user) do
    init_test_session(conn, current_user: user)
  end
end
