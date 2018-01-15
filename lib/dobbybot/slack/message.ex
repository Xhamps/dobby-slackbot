defmodule Dobbybot.Slack.Message do

  @moduledoc false

  @slack_token Application.get_env(:dobbybot, Dobbybot.Slack)[:token]

  def post_attachments(text, attachments, channel, sender \\ Slack.Web.Chat) do
    body = %{
      token: @slack_token,
      attachments: Poison.encode!(attachments)
    }

    sender.post_message(channel, text, body)
  end
end
