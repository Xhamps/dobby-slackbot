defmodule  Dobbybot.Github.ServerTest do
  use ExUnit.Case

  alias Dobbybot.Github.Server

  import Mock

  setup do
    Server.start_link()
    :ok
  end

  test "return all repos" do
    with_mock HTTPoison, [get!: &request_repos/2] do
      repos = Server.get_repos()
      [repo] = repos

      assert Enum.count(repos) == 1
      assert repo.name == "repos"
    end
  end

  test "return all pull" do
    with_mock HTTPoison, [get!: &request_pulls/2] do
      pulls = Server.get_pulls("repos1")
      [pull] = pulls

      assert Enum.count(pulls) == 1
      assert pull.name == "pulls"
    end
  end

  test "return all reviews" do
    with_mock HTTPoison, [get!: &request_reviews/2] do
      reviews = Server.get_reviews("pull1", "repos1")
      [review] = reviews

      assert Enum.count(reviews) == 1
      assert review.name == "reviews"
    end
  end

  def request_repos(request_url, header) do
    header_assert(header)

    url = "https://api.github.com/orgs/elixir-lang/repos"

    assert request_url == url

    %{body: ~s([{"name": "repos"}]), status_code: 200, headers: %{}}
  end

  def request_pulls(request_url, header) do
    header_assert(header)

    url = "https://api.github.com/repos/elixir-lang/repos1/pulls"

    assert request_url == url

    %{body: ~s([{"name": "pulls"}]), status_code: 200, headers: %{}}
  end

  def request_reviews(request_url, header) do
    header_assert(header)

    url = "https://api.github.com/repos/elixir-lang/repos1/pulls/pull1/reviews"

    assert request_url == url

    %{body: ~s([{"name": "reviews"}]), status_code: 200, headers: %{}}
  end

  def header_assert(header) do
    [auth, accept] = header

    assert auth == {"Authorization", "Bearer "}
    assert accept == {
      "Accept",
      "application/vnd.github.machine-man-preview+json"
    }
  end

end
