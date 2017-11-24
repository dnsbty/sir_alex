defmodule SirAlexWeb.MemberController do
  use SirAlexWeb, :controller
  import SirAlexWeb.Plugs.RequireLogin, only: [require_login: 2]

  alias SirAlex.Groups
  alias SirAlex.Groups.Group

  plug :get_group
  plug :require_login when not action in [:index]

  action_fallback SirAlexWeb.FallbackController

  def index(%{assigns: %{group: group}} = conn, _params) do
    members = Groups.list_members(group.id)
    render(conn, "index.html", members: members)
  end

  def create(%{assigns: %{current_user: user, group: group}} = conn, _) do
    with {:ok, member} <- Groups.add_member(group, user) do
      conn
      |> put_flash(:info, "You succesfully joined #{group.name}!")
      |> redirect(to: group_path(conn, :show, member.group_id))
    end
  end

  def leave(%{assigns: %{current_user: user, group: group}} = conn, _) do
    with {1, nil} <- Groups.remove_member(group.id, user.id) do
      conn
      |> put_flash(:info, "Successfully left the group.")
      |> redirect(to: group_path(conn, :show, group.id))
    end
  end

  def delete(%{assigns: %{group: group}} = conn, %{"id" => user_id}) do
    with {1, nil} <- Groups.remove_member(group.id, user_id) do
      conn
      |> put_flash(:info, "Successfully removed that user from the group.")
      |> redirect(to: member_path(conn, :index, group))
    end
  end

  defp get_group(%{assigns: %{current_user: user}, params: %{"group_id" => group_id}} = conn, _) do
    with {:ok, group} <- Groups.get_group_and_membership(group_id, user.id) do
      conn
      |> assign(:group, group.group)
      |> assign(:is_member?, group.is_member?)
      |> assign(:is_admin?, group.is_admin?)
      |> assign(:has_requested?, group.has_requested?)
    else
      error -> fallback(conn, error)
    end
  end
  defp get_group(%{params: %{"group_id" => group_id}} = conn, _) do
    with %Group{} = group <- Groups.get_group(group_id) do
      conn
      |> assign(:group, group)
      |> assign(:is_member?, false)
      |> assign(:is_admin?, false)
      |> assign(:has_requested?, false)
    else
      error -> fallback(conn, error)
    end
  end
  defp fallback(conn, error) do
    conn
    |> SirAlexWeb.FallbackController.call(error)
    |> halt()
  end
end
