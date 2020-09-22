defmodule Pluggy.Group do
  defstruct(id: nil, name: "")

  alias Pluggy.Group
  alias Pluggy.Student

  def get(id) do
    Postgrex.query!(DB, "SELECT id, name FROM groups WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def get_id(name) do
    Postgrex.query!(DB, "SELECT id FROM groups WHERE name = $1", [name], pool: DBConnection.ConnectionPool)
  end

  def get_all() do
    Postgrex.query!(DB, "SELECT id FROM groups", [], pool: DBConnection.ConnectionPool).rows
    |> get_all()
  end
  defp get_all([]), do: []
  defp get_all([[head]|tail]), do: [Group.get(head)|get_all(tail)]

  def get_students(group_id) do
    Postgrex.query!(DB, "SELECT id FROM students WHERE group_id = $1", [group_id], pool: DBConnection.ConnectionPool).rows
    |> _get_students()
  end
  defp _get_students([]), do: []
  defp _get_students([[head]|tail]), do: [Student.get(head)|_get_students(tail)]

  def create(name, school_id) do
    Postgrex.query!(DB, "INSERT INTO groups(name, school_id) VALUES($1, $2)", [name, school_id], pool: DBConnection.ConnectionPool)
  end

  def delete(id) do
    Postgrex.query!(DB, "SELECT id FROM students WHERE group_id = $1", [id], pool: DBConnection.ConnectionPool).rows
    |> Enum.each(fn [id] -> Student.delete(id) end)
    Postgrex.query!(DB, "DELETE FROM groups WHERE id = $1", [id], pool: DBConnection.ConnectionPool)
  end

  def to_struct([[id, name]]) do
    %Group{id: id, name: name}
  end
end
