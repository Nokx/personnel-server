# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :personnel_server,
  ecto_repos: [PersonnelServer.Repo]

# Configures the endpoint
config :personnel_server, PersonnelServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "",
  render_errors: [view: PersonnelServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PersonnelServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "PersonnelServer",
  ttl: { 3, :days },
  verify_issuer: true,
  secret_key: "",
  serializer: PersonnelServer.Accounts.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
