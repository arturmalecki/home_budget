# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :home_budget,
  ecto_repos: [HomeBudget.Repo]

# Configures the endpoint
config :home_budget, HomeBudget.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UeKw642ya8ei+r7ZhhcSwz60YmUTowH5u13UVx/LktOBExBf8CqzftePPinVxv6j",
  render_errors: [view: HomeBudget.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HomeBudget.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :guardian, Guardian,
  issuer: "HomeBudget",
  ttl: { 30, :days },
  secret_key: "Super_secret_key",
  serializer: HomeBudget.GuardianSerializer