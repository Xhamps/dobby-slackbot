defmodule Dobbybot.Slack.Message.Repos do
  @moduledoc false

  alias Dobbybot.Slack.Message.PRs

  def parse(repos) do
    repos
    |> Enum.map(&mapper/1)
  end

  def mapper (%{pulls: pulls, full_name: full_name}) do
    %{
      text: "[#{full_name}]",
      attachments: PRs.parse(pulls)
    }
  end
end
