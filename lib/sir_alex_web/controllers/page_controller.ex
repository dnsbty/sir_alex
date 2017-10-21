defmodule SirAlexWeb.PageController do
  use SirAlexWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
