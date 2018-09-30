defmodule Dobbybot.Slack.MessageTest do
  use ExUnit.Case

  alias Dobbybot.Slack.Message

  defmodule ChatMock do
    def post_message(channel, text, body) do
      attachments = [%{id: 1}, %{id: 2}]

      assert channel == "channel"
      assert text == "Message"
      assert body.token == "XXXX"
      assert body.attachments == Poison.encode!(attachments)
    end
  end

  test "post message to slack" do
    attachments = [%{id: 1}, %{id: 2}]
    Message.post_attachments("Message", attachments, "channel", ChatMock)
  end

  test "get command" do
    assert Message.get_command("<@1> command", %{me: %{id: 1}}) == "command"
  end

  test "return empty value when the message not to bot" do
    assert Message.get_command("<@2> command", %{me: %{id: 1}}) == ""
  end
end
