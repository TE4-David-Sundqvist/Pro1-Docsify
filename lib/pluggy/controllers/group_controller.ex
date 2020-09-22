defmodule Pluggy.GroupController do

  import Plug.Conn, only: [send_resp: 3]
  alias Pluggy.User
  alias Pluggy.Group
  import Pluggy.Template

  def add(conn, %{"name" => name}, school_id) do
    Group.create(name, school_id)
    redirect(conn, "/admin/school/#{school_id}")
  end

  def delete(conn, school_id, group_id) do
    Group.delete(group_id)
    redirect(conn, "/admin/school/#{school_id}")
  end

  def show(conn, id) do
    send_resp(conn, 200, srender("admin_group", [students: Group.get_students(id)]))
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
