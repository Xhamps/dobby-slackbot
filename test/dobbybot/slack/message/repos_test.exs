defmodule Dobbybot.Slack.Message.ReposTest do
  use ExUnit.Case

  alias Dobbybot.Slack.Message.Repos

  test "return the new object with text and attachments of parse" do
    repos = get_repos()
    results = Repos.parse(repos)
    [repo] = results

    assert repo.text == "[elixir-lang/elixir]"
    assert Enum.count(repo.attachments) == 2
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
