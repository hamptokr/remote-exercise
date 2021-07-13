# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :remote_exercise,
  ecto_repos: [RemoteExercise.Repo]

# Configures the endpoint
config :remote_exercise, RemoteExerciseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZHCuD+vN4DUJ0fP5g5BqnfpEyxiUZn3/IKFBhTulWqSucDr/7S4WwSUB0bkYA92a",
  render_errors: [view: RemoteExerciseWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: RemoteExercise.PubSub,
  live_view: [signing_salt: "suO1x6iF"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
