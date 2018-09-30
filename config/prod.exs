use Mix.Config

config :dobbybot, Dobbybot.Slack, token: System.get_env("SLACK_TOKEN")
config :dobbybot, :site_github, "https://api.github.com"
config :dobbybot, :token_github, System.get_env("GITHUB_TOKEN")
config :dobbybot, :org_github, System.get_env("GITHUB_ORG")
config :dobbybot, :server_github, Dobbybot.Plugins.Github.Server
