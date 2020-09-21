defmodule Pluggy.UserController do

  import Plug.Conn, only: [send_resp: 3]
  alias Pluggy.User
  import Pluggy.Template, only: [srender: 1]

  def login(conn, params) do
    username = params["username"]
    password = params["pwd"]

    result = Pluggy.User.get_id(username)

    case result.num_rows do
      0 ->
        redirect(conn, "/")
      _ ->
        [[id, password_hash]] = result.rows

        if Bcrypt.verify_pass(password, password_hash) do
          if Pluggy.User.admin?(id) do
            Plug.Conn.put_session(conn, :user_id, id)
            |> redirect("/admin/home")
          else
            Plug.Conn.put_session(conn, :user_id, id)
            |> redirect("/home")
          end
        else
          redirect(conn, "/")
        end
    end
  end

  def logout(conn) do
    Plug.Conn.configure_session(conn, drop: true)
    |> redirect("/")
  end

  def home(conn) do
    if Pluggy.User.logged_in?(conn) do
      if User.admin?(Plug.Conn.get_session(conn, :user_id)) do
        redirect(conn, "/admin/home")
      else
        send_resp(conn, 200, srender("home"))
      end
    else
      redirect(conn, "/")
    end
  end

  # def create(conn, params) do
  # 	pseudocode
  # 	in db table users with password_hash CHAR(60)
  # 	hashed_password = Bcrypt.hash_pwd_salt(params["password"])
  #  	Postgrex.query!(DB, "INSERT INTO users (username, password_hash) VALUES ($1, $2)", [params["username"], hashed_password], [pool: DBConnection.ConnectionPool])
  #  	redirect(conn, "/fruits")
  # end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
