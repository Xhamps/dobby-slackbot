defmodule Dobbybot.Plugins.Ping.Command do

  @commands [
    %{ action: "ping", description: "Ping pong", validation: ~r/ping$/ }
  ]

  def commands, do: @commands

  def run("ping", _command) do
    %{text: "pong"}
  end
end
