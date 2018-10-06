use Mix.Config

config :dobbybot, Dobbybot.Slack, token: "XXXX"
config :dobbybot, :server_github, Dobbybot.Plugins.Github.ServerMock
config :dobbybot, :env, :test
