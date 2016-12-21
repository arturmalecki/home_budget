use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :home_budget, HomeBudget.Endpoint,
  http: [port: 4040],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :home_budget, HomeBudget.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :home_budget, HomeBudget.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "artur",
  password: "",
  database: "home_budget_dev",
  hostname: "localhost",
  pool_size: 10

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
