defmodule Pluggy.Teacher do
  defstruct(id: nil, name: "")

  alias Pluggy.Teacher

  def get(id) do
    Postgrex.query!(DB, "SELECT id, username FROM users WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def get_id(name) do
    Postgrex.query!(DB, "SELECT id FROM users WHERE name = $1", [name], pool: DBConnection.ConnectionPool)
  end

  def get_all() do
    Postgrex.query!(DB, "SELECT id FROM users", [], pool: DBConnection.ConnectionPool).rows
    |> get_all()
  end
  defp get_all([]), do: []
  defp get_all([[head]|tail]), do: [Teacher.get(head)|get_all(tail)]

  def create(user_id, school_id) do
    Postgrex.query!(DB, "INSERT INTO teachers(user_id, school_id) VALUES($1, $2)", [user_id, school_id], pool: DBConnection.ConnectionPool)
  end

  def delete(user_id, school_id) do
    Postgrex.query!(DB, "DELETE FROM teachers WHERE user_id = $1 AND school_id = $2", [user_id, school_id], pool: DBConnection.ConnectionPool)
  end

  def to_struct([[id, name]]) do
    %Teacher{id: id, name: name}
  end
end
