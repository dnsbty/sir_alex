defmodule SirAlexWeb.FallbackController do
  use SirAlexWeb, :controller
  require Logger

  def call(conn, {:error, %Ecto.NoResultsError{}}) do
    conn
    |> put_status(404)
    |> render(SirAlexWeb.ErrorView, "404.html")
  end

  def call(conn, error) do
    error
    |> inspect()
    |> Logger.error()

    conn
    |> put_status(500)
    |> render(SirAlexWeb.ErrorView, "500.html")
  end
end
