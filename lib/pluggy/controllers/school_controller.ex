defmodule Pluggy.SchoolController do

  import Plug.Conn, only: [send_resp: 3]
  alias Pluggy.User
  alias Pluggy.School
  import Pluggy.Template

  def add(conn, %{"name" => name}) do
    School.create(name)
    redirect(conn, "/admin/home")
  end

  def delete(conn, id) do
    School.delete(id)
    redirect(conn, "/admin/home")
  end

  def show(conn, id) do
    send_resp(conn, 200, srender("admin_school", [groups: School.get_groups(id), teachers: School.get_teachers(id), school: School.get(id)]))
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
