defmodule Dobbybot.Slack.Message do

  @moduledoc false

  def post_attachments(text, attachments, channel, sender \\ Slack.Web.Chat) do
    body = %{
      token: Application.get_env(:dobbybot, Dobbybot.Slack)[:token],
      attachments: Poison.encode!(attachments)
    }

    sender.post_message(channel, text, body)
  end

  def get_command(text, slack) do
    case Regex.run(~r/<@#{slack.me.id}>:?\s(.+)/ , text) do
      nil -> ""
      [_result, text] -> text
    end
  end

end
