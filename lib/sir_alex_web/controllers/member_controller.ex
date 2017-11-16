defmodule SirAlexWeb.MemberController do
  use SirAlexWeb, :controller
  import SirAlexWeb.Plugs.RequireLogin, only: [require_login: 2]

  alias Plug.Conn
  alias SirAlex.Groups
  alias SirAlex.Groups.{
    Group,
    Member
  }

  plug :get_group when not action in [:update]
  plug :require_login when action in [:create]

  action_fallback SirAlexWeb.FallbackController

  def index(conn, _params) do
    members = Groups.list_members()
    render(conn, "index.html", members: members)
  end

  def new(conn, _params) do
    changeset = Groups.change_member(%Member{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_user: user, group: group}} = conn, _) do
    with {:ok, member} <- Groups.add_member(group, user) do
      conn
      |> put_flash(:info, "You succesfully joined #{group.name}!")
      |> redirect(to: group_path(conn, :show, member.group_id))
    end
  end

  def show(conn, %{"id" => id}) do
    member = Groups.get_member!(id)
    render(conn, "show.html", member: member)
  end

  def edit(conn, %{"id" => id}) do
    member = Groups.get_member!(id)
    changeset = Groups.change_member(member)
    render(conn, "edit.html", member: member, changeset: changeset)
  end

  def update(conn, %{"id" => id, "member" => member_params}) do
    member = Groups.get_member!(id)

    case Groups.update_member(member, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member updated successfully.")
        |> redirect(to: member_path(conn, :show, member.group_id, member))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", member: member, changeset: changeset)
    end
  end

  def delete(%{assigns: %{current_user: user, group: group}} = conn, _) do
    IO.puts("deleting...")
    with {1, nil} <- Groups.remove_member(group.id, user.id) do
      conn
      |> put_flash(:info, "Successfully left the group.")
      |> redirect(to: group_path(conn, :show, group.id))
    end
  end

  defp get_group(%{params: %{"group_id" => group_id}} = conn, _) do
    with %Group{} = group <- Groups.get_group(group_id) do
      Conn.assign(conn, :group, group)
    end
  end
end
