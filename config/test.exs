use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :home_budget, HomeBudget.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :home_budget, HomeBudget.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "artur",
  password: "",
  database: "home_budget_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
