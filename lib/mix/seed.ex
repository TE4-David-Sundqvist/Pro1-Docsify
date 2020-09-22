defmodule Mix.Tasks.Seed do
  use Mix.Task

  import Bcrypt

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS schools", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS teachers", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS groups", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS students", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")
    Postgrex.query!(DB, "Create TABLE users (id SERIAL, username VARCHAR NOT NULL, password_hash VARCHAR NOT NULL, admin INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE schools (id SERIAL, name VARCHAR NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE teachers (user_id SERIAL, school_id SERIAL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE groups (id SERIAL, name VARCHAR NOT NULL, school_id INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE students (id SERIAL, name VARCHAR NOT NULL, group_id INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
  end

  defp seed_data() do
    IO.puts("Seeding data")
    Postgrex.query!(DB, "INSERT INTO users(username, password_hash, admin) VALUES($1, $2, $3)", ["admin", Bcrypt.hash_pwd_salt("admin"), 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO users(username, password_hash, admin) VALUES($1, $2, $3)", ["Sebbe", Bcrypt.hash_pwd_salt("Sebbe"), 0], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO users(username, password_hash, admin) VALUES($1, $2, $3)", ["David", Bcrypt.hash_pwd_salt("David"), 0], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "INSERT INTO schools(name) VALUES($1)", ["NTI Johanneberg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO schools(name) VALUES($1)", ["ITG"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO teachers(user_id, school_id) VALUES($1, $2)", [1, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO groups(name, school_id) VALUES($1, $2)", ["Te4", 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students(name, group_id) VALUES($1, $2)", ["Stefan Löfven", 1], pool: DBConnection.ConnectionPool)
  end

end
