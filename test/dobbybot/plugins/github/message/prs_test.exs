Code.require_file("reviews_test.exs", __DIR__)

defmodule Dobbybot.Plugins.Github.Message.PRsTest do
  use ExUnit.Case

  alias Dobbybot.Plugins.Github.Message.PRs
  alias Dobbybot.Plugins.Github.Message.ReviewsTest


  test "return all PRs grouped" do
    pulls =  [
      mock_pull(:approved, 'Pull Request 3', 'link-3', '1 hour ago'),
      mock_pull(:approved, 'Pull Request 2', 'link-2', '3 days ago'),
      mock_pull(:unapproved, 'Pull Request 1', 'link-1', '7 days ago'),
    ]
    results = PRs.parse(pulls)

    assert length(results) == 2
  end

  test "return object approved with " do
    pulls =  [
      mock_pull(:approved, 'Pull Request 1', 'link-1', '1 hour ago')
    ]
    results = PRs.parse(pulls)
    [approved] = results

    assert approved[:color] == "#36a64f"
    assert approved[:title] == "Approved"
    assert String.starts_with?(approved[:text], "<link-1|Pull Request 1> - `1 hour ago`\n")
  end

  test "return object unapproved with " do
    pulls =  [
      mock_pull(:unapproved, 'Pull Request 1', 'link-1', '1 hour ago')
    ]
    results = PRs.parse(pulls)
    [unapproved] = results

    assert unapproved[:color] == "#FF0000"
    assert unapproved[:title] == "Unapproved"
    assert String.starts_with?(unapproved[:text], "<link-1|Pull Request 1> - `1 hour ago`\n")
  end


  def mock_pull(:approved, title, url, time) do
    %{
      title: title,
      url: url,
      time: time,
      reviews: [
        ReviewsTest.mock_review(:approved, "user_1"),
        ReviewsTest.mock_review(:approved, "user_2")
      ],
      is_approved: true
    } 
  end
  def mock_pull(:unapproved, title, url, time) do
    %{
      title: title,
      url: url,
      time: time,
      reviews: [
        ReviewsTest.mock_review(:request_changes, "user_1"),
        ReviewsTest.mock_review(:approved, "user_2")
      ],
      is_approved: false
    } 
  end

end
