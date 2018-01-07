use Mix.Config

config :dobbybot, Dobbybot.Slack, token: System.get_env("SLACK_TOKEN")
config :dobbybot, :server_github, Dobbybot.Github.ServerMock
