defmodule Dobbybot.Plugins.Github.Message.PRs do
  @moduledoc false

  alias Dobbybot.Plugins.Github.Message.Reviews

  def parse(pulls) do
    pulls
    |> Enum.group_by(& Map.get(&1, :is_approved))
    |> Enum.map(&mapper/1)
  end

  def mapper({k, v}) do

    text = v
    |> Enum.map(&mapper_text/1)
    |> Enum.join("\n")

    %{
      text: text,
      color: if(k, do: "#36a64f", else: "#FF0000"),
      title: if(k, do: "Approved", else: "Unapproved"),
      mrkdwn_in: "text"
    }
  end

  def mapper_text(%{title: title, url: url, time: time, reviews: reviews}) do
    "<#{url}|#{title}> - `#{time}`\n #{Reviews.parse(reviews)}"
  end

end
