defmodule Dobbybot.Slack.Responses.PRsTest do
  use ExUnit.Case

  alias Dobbybot.Github
  alias Dobbybot.Slack.Message
  alias Dobbybot.Slack.Responses.PRs

  import Mock

  test "parse and send messages to slack" do
    with_mocks([
      {
        Github,
        [],
        [get_repos: &get_repos/0]
      },
      {
        Message,
        [],
        [post_attachments: fn (text, attachments, channel) ->
          assert text == "[elixir-lang/elixir]"
          assert Enum.count(attachments) == 2
          assert channel == "channel"
        end]
      }
    ]) do
      result = PRs.run(%{channel: "channel"})
      assert Enum.count(result) == 1
    end
  end

  def get_repos do
    [%{
        full_name: "elixir-lang/elixir",
        pulls: get_pulls()
     }]
  end

  def get_pulls do
    [
      %{
        title: "Elixir",
        html_url: "http://github.com/elixir-lang/elixir",
        time: "3 meses atrás"
      },
      %{
        title: "Elixir",
        html_url: "http://github.com/elixir-lang/elixir",
        time: "3 meses atrás"
      }
    ]
  end

end
