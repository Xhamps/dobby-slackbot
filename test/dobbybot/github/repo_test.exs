defmodule Dobbybot.Github.RepoTest do
  use ExUnit.Case

  alias Dobbybot.Github.Repo

  test "should return all repos" do
    repos = Repo.get_all()

    assert Enum.count(repos) == 2
  end

  test "should set pull into repos struct" do
    repo = %{}
    pulls = [%{id: 1}, %{id: 2}]

    new_repo = Repo.add_pulls(pulls, repo)

    assert new_repo.pulls == pulls
  end
end
