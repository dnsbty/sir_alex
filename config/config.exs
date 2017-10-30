# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sir_alex,
  ecto_repos: [SirAlex.Repo]

# Configures the endpoint
config :sir_alex, SirAlexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Jkzv14qgzwNOVBbtQxnEqQvBD6Aar6BJp5p6c+6va8GdoSFzlKeDWt57s7FRp8RY",
  render_errors: [view: SirAlexWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SirAlex.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Ueberauth for OAuth login
config :ueberauth, Ueberauth,
  providers: [
    facebook: {
      Ueberauth.Strategy.Facebook, [default_scope: "email,public_profile,user_friends"]
    }
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
