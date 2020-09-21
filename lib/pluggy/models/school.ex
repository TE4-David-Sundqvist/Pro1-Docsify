defmodule Pluggy.School do
  defstruct(id: nil, name: "")

  alias Pluggy.School

  def get(id) do
    Postgrex.query!(DB, "SELECT id, name FROM schools WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def get_id(username) do
    Postgrex.query!(DB, "SELECT id FROM schools WHERE username = $1", [username], pool: DBConnection.ConnectionPool)
  end

  def get_all() do
    id_list = Postgrex.query!(DB, "SELECT id FROM schools", [], pool: DBConnection.ConnectionPool).rows
    get_all(id_list)
  end
  defp get_all([]), do: []
  defp get_all([[head]|tail]), do: [School.get(head)|get_all(tail)]

  def create(name) do
    Postgrex.query!(DB, "INSERT INTO schools(name) VALUES($1)", [name], pool: DBConnection.ConnectionPool)
  end

  def delete(id) do
    # Postgrex.query!(DB, "DELETE FROM students WHERE group_id = $1", [id], pool: DBConnection.ConnectionPool)
    # Postgrex.query!(DB, "DELETE FROM groups WHERE school_id = $1", [id], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DELETE FROM schools WHERE id = $1", [id], pool: DBConnection.ConnectionPool)
  end

  def to_struct([[id, name]]) do
    %School{id: id, name: name}
  end
end
