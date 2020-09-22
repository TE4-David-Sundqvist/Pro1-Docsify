defmodule Pluggy.School do
  defstruct(id: nil, name: "")

  alias Pluggy.School
  alias Pluggy.Group
  alias Pluggy.Teacher

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
    Postgrex.query!(DB, "SELECT id FROM schools", [], pool: DBConnection.ConnectionPool).rows
    |> get_all()
  end
  defp get_all([]), do: []
  defp get_all([[head]|tail]), do: [School.get(head)|get_all(tail)]

  def get_groups(id) do
    Postgrex.query!(DB, "SELECT id FROM groups WHERE school_id = $1", [id], pool: DBConnection.ConnectionPool).rows
    |> _get_groups()
  end
  defp _get_groups([]), do: []
  defp _get_groups([[head]|tail]), do: [Group.get(head)|_get_groups(tail)]

  def get_teachers(id) do
    Postgrex.query!(DB, "SELECT user_id FROM teachers WHERE school_id = $1", [id], pool: DBConnection.ConnectionPool).rows
    |> _get_teachers()
  end
  defp _get_teachers([]), do: []
  defp _get_teachers([[head]|tail]), do: [Teacher.get(head)|_get_teachers(tail)]

  def create(name) do
    Postgrex.query!(DB, "INSERT INTO schools(name) VALUES($1)", [name], pool: DBConnection.ConnectionPool)
  end

  def delete(id) do
    Postgrex.query!(DB, "SELECT id FROM groups WHERE school_id = $1", [id], pool: DBConnection.ConnectionPool).rows
    |> Enum.each(fn [id] -> Group.delete(id) end)
    Postgrex.query!(DB, "DELETE FROM teachers WHERE school_id = $1", [id], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DELETE FROM schools WHERE id = $1", [id], pool: DBConnection.ConnectionPool)
  end

  def to_struct([[id, name]]) do
    %School{id: id, name: name}
  end
end
