use Mix.Config

config :dobbybot, Dobbybot.Slack, token: System.get_env("SLACK_TOKEN")
config :dobbybot, :site_github, "https://api.github.com"
config :dobbybot, :token_github, "YOUR_ORGANIZATION"
config :dobbybot, :server_github, Dobbybot.Plugins.Github.Server
config :dobbybot, :env, :dev


