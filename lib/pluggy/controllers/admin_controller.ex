defmodule Pluggy.AdminController do

  import Plug.Conn, only: [send_resp: 3]
  alias Pluggy.User
  alias Pluggy.School
  import Pluggy.Template

  @spec home(Plug.Conn.t()) :: Plug.Conn.t()
  def home(conn) do
    if Pluggy.User.logged_in?(conn) do
      if User.admin?(Plug.Conn.get_session(conn, :user_id)) do
        send_resp(conn, 200, srender("admin_home", [schools: School.get_all()]))
      else
        redirect(conn, "/home")
      end
    else
      redirect(conn, "/")
    end
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
