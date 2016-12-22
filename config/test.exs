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

config :guardian, Guardian,
  allowed_algos: ["ES512"],
  issuer: "HomeBudget",
  ttl: { 30, :days },
  serializer: HomeBudget.GuardianSerializer,
  secret_key: %{
    "crv" => "P-521",
    "d" => "t448_42yrdbLASkHUvgPH0g8lvCCVmgKdTYeUODr6fI3rDSs41B6jmBhCyjcgnho9sOXgMOfSgRfmqyOCQuW4Kw",
    "kty" => "EC",
    "x" => "ANTQQSkUGOUHmTKe_9-MgDisqdcz3fBPMUeYUmtDhRsdg5NQmHQBbnWfMPB3Px4l4DIJY8bWRVejv6Z2yclpg80m",
    "y" => "AET6RGnO4Tqj4V8NMMtT7fpRWQ68x4rmxQkLO5-jUTsEbWcgeW_SFlbM9JE2jLujjHSqTDDboAbD2SYDo1XzAzBM"
  }

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1
