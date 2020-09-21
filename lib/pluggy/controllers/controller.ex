defmodule Pluggy.Controller do

  import Plug.Conn, only: [send_resp: 3]
  import Pluggy.User
  import Pluggy.Template, only: [srender: 1]

  def index(conn) do
    id = Plug.Conn.get_session(conn, :user_id)
    if id == nil do
      send_resp(conn, 200, srender("login"))
    else
      if Pluggy.User.admin?(id) do
        redirect(conn, "admin_home")
      else
        redirect(conn, "home")
      end
    end
  end

  def home(conn) do



    if Plug.Conn.get_session(conn, :admin) == 1 do
      send_resp(conn, 200, srender("adminhome"))
    else
      send_resp(conn, 200, srender("home"))
    end
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
