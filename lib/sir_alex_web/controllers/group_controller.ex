defmodule SirAlexWeb.GroupController do
  use SirAlexWeb, :controller
  import SirAlexWeb.Plugs.RequireLogin, only: [require_login: 2]

  alias SirAlex.Groups
  alias SirAlex.Groups.Group

  plug :get_group when action in [:show, :edit, :update, :delete]
  plug :require_login when action in [:new, :create]
  plug :requires_group_admin when action in [:edit, :update, :delete]
  action_fallback SirAlexWeb.FallbackController

  def index(conn, _params) do
    groups = Groups.list_groups()
    render(conn, "index.html", groups: groups)
  end

  def new(conn, _params) do
    changeset = Groups.change_group(%Group{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_user: user}} = conn, %{"group" => group_params}) do
    case Groups.create_group_and_admin(group_params, user) do
      {:ok, group} ->
        conn
        |> put_flash(:info, "Group created successfully.")
        |> redirect(to: group_path(conn, :show, group))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end

  def edit(%{assigns: %{group: group}} = conn, _params) do
    changeset = Groups.change_group(group)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(%{assigns: %{group: group}} = conn, %{"group" => group_params}) do
    case Groups.update_group(group, group_params) do
      {:ok, group} ->
        conn
        |> put_flash(:info, "Group updated successfully.")
        |> redirect(to: group_path(conn, :show, group))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", group: group, changeset: changeset)
    end
  end

  def delete(%{assigns: %{group: group}} = conn, _params) do
    {:ok, _group} = Groups.delete_group(group)

    conn
    |> put_flash(:info, "Group deleted successfully.")
    |> redirect(to: group_path(conn, :index))
  end

  defp get_group(%{assigns: %{current_user: user}, params: %{"id" => group_id}} = conn, _) do
    with {:ok, group} <- Groups.get_group_and_membership(group_id, user.id) do
      conn
      |> assign(:group, group.group)
      |> assign(:is_member?, group.is_member?)
      |> assign(:is_admin?, group.is_admin?)
    else
      error ->
        conn
        |> SirAlexWeb.FallbackController.call(error)
        |> halt()
    end
  end

  defp requires_group_admin(%{assigns: %{is_admin?: true}} = conn, _), do: conn
  defp requires_group_admin(%{assigns: %{is_admin?: false, group: group}} = conn, _) do
    conn
    |> put_flash(:error, "You must be an admin of the group to do that")
    |> redirect(to: group_path(conn, :show, group))
    |> halt()
  end
end
