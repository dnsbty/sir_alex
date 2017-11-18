defmodule SirAlexWeb.GroupView do
  use SirAlexWeb, :view
  alias SirAlex.Groups.Group

  def action_button(conn, %Group{is_private?: false} = group, false) do
    join_button("Join Group", conn, group)
  end
  def action_button(conn, %Group{is_private?: true} = group, false) do
    join_button("Request to Join Group", conn, group)
  end
  def action_button(conn, group, true) do
    options = [
      to: member_path(conn, :delete, group),
      method: :delete,
      class: "btn btn-secondary"
    ]
    link("Leave Group", options)
  end

  defp join_button(link_text, conn, group) do
    options = [
      to: member_path(conn, :create, group),
      method: :post,
      class: "btn btn-primary"
    ]
    link(link_text, options)
  end
end
