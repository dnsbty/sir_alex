defmodule SirAlexWeb.MemberRequestController do
  use SirAlexWeb, :controller
  import SirAlexWeb.Plugs.RequireLogin, only: [require_login: 2]

  alias SirAlex.Groups

  plug :require_login
  plug :get_group
  plug :requires_group_admin

  def index(%{assigns: %{group: group}} = conn, _params) do
    requests = Groups.list_member_requests(group.id)
    render(conn, "index.html", requests: requests)
  end

  def accept(%{assigns: %{group: group}} = conn, %{"member_id" => user_id}) do
    with {1, _} <- Groups.accept_member_request(group.id, user_id) do
      conn
      |> put_flash(:info, "Request was successfully accepted")
      |> redirect(to: member_request_path(conn, :index, group.id))
    end
  end

  def reject(%{assigns: %{group: group}} = conn, %{"member_id" => user_id}) do
    with {1, _} <- Groups.reject_member_request(group.id, user_id) do
      conn
      |> put_flash(:info, "Request was successfully accepted")
      |> redirect(to: member_request_path(conn, :index, group.id))
    end
  end

  defp get_group(%{assigns: %{current_user: user}, params: %{"group_id" => group_id}} = conn, _) do
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
