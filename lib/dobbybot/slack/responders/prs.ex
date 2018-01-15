defmodule Dobbybot.Slack.Responses.PRs do

  @moduledoc false

  alias Dobbybot.Github
  alias Dobbybot.Slack.Message
  alias Dobbybot.Slack.Message.Repos

  def run(%{channel: channel}) do
    Github.get_repos()
    |> Repos.parse()
    |> Enum.map(fn (%{text: text, attachments: attachments}) ->
      Message.post_attachments(text, attachments, channel) end)
  end
end
