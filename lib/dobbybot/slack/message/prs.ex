defmodule Dobbybot.Slack.Message.PRs do
  @moduledoc false


  def parse(pulls) do
    pulls
    |> Enum.map(&mapper/1)
  end

  def mapper(%{title: title, html_url: url, time: time}) do
      %{
        text: time,
        color: "#36a64f",
        title: title,
        title_link: url,
        mrkdwn_in: "text"
      }
  end
end
