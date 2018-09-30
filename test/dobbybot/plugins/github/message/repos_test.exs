Code.require_file("prs_test.exs", __DIR__)

defmodule Dobbybot.Plugins.Github.Message.ReposTest do
  use ExUnit.Case

  alias Dobbybot.Plugins.Github.Message.Repos
  alias Dobbybot.Plugins.Github.Message.PRsTest

  test "return the new object with text and attachments of parse" do
    repos = mock_repos()
    results = Repos.parse(repos)
    [repo] = results

    assert repo.text == "[elixir-lang/elixir]"
    assert Enum.count(repo.attachments) == 2
  end

  def mock_repos do
    [%{
        name: "elixir-lang/elixir",
        pullRequests: [
          PRsTest.mock_pull(:approved, 'Pull Request 2', 'link-2', '1 hour ago'),
          PRsTest.mock_pull(:unapproved, 'Pull Request 1', 'link-1', '7 days ago')
        ]
     }]
  end
end
