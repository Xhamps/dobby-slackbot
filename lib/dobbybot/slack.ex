defmodule Dobbybot.Slack do
  use Slack

  @moduledoc false

  alias Dobbybot.Slack.Responses.PRs

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    if Regex.run ~r/<@#{slack.me.id}>:?\sping/, message.text do
      send_message("<@#{message.user}> pong", message.channel, slack)
    end

    if Regex.run ~r/<@#{slack.me.id}>:?\sprs/, message.text do
      PRs.run(message)
    end

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}


  def handle_message(message = %{type: 'message'}, _slack, state) do
    {:ok, state}
  end
  def handle_message(_message, _slack, state), do: {:ok, state}

  def handle_info({_, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"
    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
