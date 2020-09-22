defmodule Pluggy.TeacherController do

  import Plug.Conn, only: [send_resp: 3]
  alias Pluggy.User
  alias Pluggy.Teacher
  import Pluggy.Template

  def add(conn, %{"name" => name}, school_id) do
    result = User.get_id(name)
    case result.num_rows do
      0 ->
        Plug.Conn.put_session(conn, :error, "No user with that name")
      _ ->
        [[user_id, _]] = result.rows
        Teacher.create(user_id, school_id)
    end
    redirect(conn, "/admin/school/#{school_id}")
  end

  def delete(conn, school_id, user_id) do
    Teacher.delete(user_id, school_id)
    redirect(conn, "/admin/school/#{school_id}")
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
