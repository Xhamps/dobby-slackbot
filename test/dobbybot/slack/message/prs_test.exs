defmodule Dobbybot.Slack.Message.PRsTest do
  use ExUnit.Case

  alias Dobbybot.Slack.Message.PRs

  test "return the new object of parse" do
    pulls = get_pulls()
    results = PRs.parse(pulls)
    [pull] = results

    assert pull == %{
      text: "3 meses atrás",
      color: "#36a64f",
      title: "Elixir",
      title_link: "http://github.com/elixir-lang/elixir",
      mrkdwn_in: "text"
    }
  end

  def get_pulls do
    [
      %{
        title: "Elixir",
        html_url: "http://github.com/elixir-lang/elixir",
        time: "3 meses atrás"
      }
    ]
  end
end
