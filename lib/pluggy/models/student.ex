defmodule Pluggy.Student do
  defstruct(id: nil, name: "")

  alias Pluggy.Student

  def get(id) do
    Postgrex.query!(DB, "SELECT id, name FROM students WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def get_id(name) do
    Postgrex.query!(DB, "SELECT id FROM students WHERE name = $1", [name], pool: DBConnection.ConnectionPool)
  end

  def get_all() do
    Postgrex.query!(DB, "SELECT id FROM students", [], pool: DBConnection.ConnectionPool).rows
    |> get_all()
  end
  defp get_all([]), do: []
  defp get_all([[head]|tail]), do: [Student.get(head)|get_all(tail)]

  def create(name) do
    Postgrex.query!(DB, "INSERT INTO students(name) VALUES($1)", [name], pool: DBConnection.ConnectionPool)
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM students WHERE id = $1", [id], pool: DBConnection.ConnectionPool)
  end

  def to_struct([[id, name]]) do
    %Student{id: id, name: name}
  end
end
