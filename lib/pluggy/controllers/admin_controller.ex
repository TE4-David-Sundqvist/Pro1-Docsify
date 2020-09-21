defmodule Pluggy.AdminController do

  import Plug.Conn, only: [send_resp: 3]
  alias Pluggy.User
  import Pluggy.Template, only: [srender: 1]

  @spec home(Plug.Conn.t()) :: Plug.Conn.t()
  def home(conn) do
    if Pluggy.User.logged_in?(conn) do
      if User.admin?(Plug.Conn.get_session(conn, :user_id)) do
        send_resp(conn, 200, srender("admin_home"))
      else
        redirect(conn, "/home")
      end
    else
      send_resp(conn, 200, srender("/"))
    end
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
