defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger

  alias Pluggy.UserController
  alias Pluggy.Controller
  alias Pluggy.AdminController
  alias Pluggy.SchoolController
  alias Pluggy.GroupController
  alias Pluggy.TeacherController



  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES -- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get("/", do: Controller.index(conn))
  get("/home", do: UserController.home(conn))
  get("/admin/home", do: AdminController.home(conn))
  get("/logout", do: UserController.logout(conn))
  get("/admin/school/:id", do: SchoolController.show(conn, String.to_integer(id)))
  get("/admin/school/:id", do: SchoolController.show(conn, String.to_integer(id)))

  post("/login", do: UserController.login(conn, conn.body_params))
  post("/add/school", do: SchoolController.add(conn, conn.body_params))
  post("/add/group/:school_id", do: GroupController.add(conn, conn.body_params, String.to_integer(school_id)))
  post("/add/teacher/:school_id", do: TeacherController.add(conn, conn.body_params, String.to_integer(school_id)))

  get("/delete/school/:id", do: SchoolController.delete(conn, String.to_integer(id)))
  get("/delete/school/:school_id/group/:group_id", do: GroupController.delete(conn, String.to_integer(school_id), String.to_integer(group_id)))
  get("/delete/school/:school_id/teacher/:teacher_id", do: TeacherController.delete(conn, String.to_integer(school_id), String.to_integer(teacher_id)))

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
