defmodule Dobbybot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # slack_token = Application.get_env(:dobbybot, Dobbybot.Slack)[:token]
    # List all child processes to be supervised
    children = [
      # worker(Slack.Bot, [Dobbybot.Slack, [], slack_token ]),
      worker(Application.get_env(:dobbybot, :server_github), [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dobbybot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
