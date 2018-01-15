defmodule Dobbybot.GithubTest do
  use ExUnit.Case

  alias Dobbybot.Github

  test "Get all repos" do
    repos  = Github.get_repos()
    [repo1, repo2] = repos

    assert Enum.count(repos) == 2
    assert Map.has_key?(repo1, :pulls)
    assert Map.has_key?(repo2, :pulls)
  end

  test "Gell all pull" do
    pulls = Github.get_pulls(%{name: "repo1"})
    [pull1, pull2] = pulls

    assert Enum.count(pulls) == 2
    assert pull1.id == 11
    assert pull2.id == 12
  end
end
