defmodule Pluggy.User do
  defstruct(id: nil, username: "")

  alias Pluggy.User

  def get(id) do
    Postgrex.query!(DB, "SELECT id, username FROM users WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def get_id(username) do
    Postgrex.query!(DB, "SELECT id, password_hash FROM users WHERE username = $1", [username], pool: DBConnection.ConnectionPool)
  end

  def to_struct([[id, username]]) do
    %User{id: id, username: username}
  end
end
