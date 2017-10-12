use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :personnel_server, PersonnelServerWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :personnel_server, PersonnelServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "12345",
  database: "personnel_server_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  types: PersonnelServer.PostgrexTypes
