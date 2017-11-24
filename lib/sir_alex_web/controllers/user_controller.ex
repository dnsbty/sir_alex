defmodule SirAlexWeb.UserController do
  use SirAlexWeb, :controller

  alias SirAlex.Accounts
  plug :get_user when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def show(%{assigns: %{user: user}} = conn, _) do
    render(conn, "show.html", user: user)
  end

  def edit(%{assigns: %{user: user}} = conn, _) do
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(%{assigns: %{user: user}} = conn, %{"user" => user_params}) do
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(%{assigns: %{user: user}} = conn, _) do
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: page_path(conn, :index))
  end

  def get_user(%{params: %{"id" => user_id}} = conn, _) do
    with {:ok, user} <- Accounts.get_user(user_id) do
      assign(conn, :user, user)
    else
      error ->
        conn
        |> SirAlexWeb.FallbackController.call(error)
        |> halt()
    end
  end
end
