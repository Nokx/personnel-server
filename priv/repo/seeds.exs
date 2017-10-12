# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PersonnelServer.Repo.insert!(%PersonnelServer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

[
  %{
    first_name: "Admin",
    last_name: "Adminov",
    credential: %{
      email: "admin@example.com",
      password: "12345"
    }
  },
]
|> Enum.each(&PersonnelServer.Accounts.create_user(&1))
