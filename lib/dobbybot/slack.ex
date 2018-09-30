defmodule Dobbybot.Slack do
  use Slack

  alias Dobbybot.Slack.Message

  @moduledoc false

  @plugins [
    Dobbybot.Plugins.Ping.Command,
    Dobbybot.Plugins.Github.Command
  ]

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    message.text
      |> Message.get_command(slack)
      |> exec_commands(@plugins, [])
      |> List.flatten
      |> Enum.map(& post_message(&1, message, slack))

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}


  def handle_message(%{type: 'message'}, _slack, state) do
    {:ok, state}
  end
  def handle_message(_message, _slack, state), do: {:ok, state}

  def handle_info({_, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"
    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

  defp exec_commands("", _commands, _messages), do: []
  defp exec_commands(_text, [], messages), do: messages ++ []
  defp exec_commands(text, [ headCommand | tailCommands], messages) do
    result = headCommand.commands
    |> Enum.map(fn command -> %{ action: command.action, result: Regex.run(command.validation, text) } end)
    |> Enum.reject(fn %{ result: result } ->  is_nil(result) end)
    |> Enum.map(fn %{action: action, result: result} -> headCommand.run(action, result) end)


    exec_commands(text, tailCommands, result ++ messages)
  end

  defp post_message(%{text: text, attachments: attachments}, message, _slack) do
    Message.post_attachments(text, attachments, message.channel)
  end

  defp post_message(%{text: text}, message, slack) do
    send_message("<@#{message.user}>: #{text}", message.channel, slack)
  end
end
