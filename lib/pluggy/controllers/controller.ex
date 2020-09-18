defmodule Pluggy.Controller do

  import Plug.Conn, only: [send_resp: 3]
  import Pluggy.Template, only: [srender: 1]

  def index(conn) do
    if Plug.Conn.get_session(conn, :user_id) == nil do
      send_resp(conn, 200, srender("login"))
    else
      redirect(conn, "home")
    end
  end

  def home(conn) do
    if Plug.Conn.get_session(conn, :user_id) != nil do
      send_resp(conn, 200, srender("home"))
    else
      redirect(conn, "/")
    end
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
