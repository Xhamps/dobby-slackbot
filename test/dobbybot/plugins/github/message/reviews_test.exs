defmodule Dobbybot.Plugins.Github.Message.ReviewsTest do
  use ExUnit.Case

  alias Dobbybot.Plugins.Github.Message.Reviews

  test "return the message with login and icon of all reviews" do
    reviews = mock_reviews()

    assert Reviews.parse(reviews) === ":white_check_mark: user_1 - :question: user_2 - :no_entry_sign: user_3"
  end

  def mock_reviews do
    [
      mock_review(:approved, "user_1"),
      mock_review(:commented, "user_2"),
      mock_review(:request_changes, "user_3")
    ]
  end

  def mock_review(:approved, login), do:  %{ state: "APPROVED", author: %{ login: login } }
  def mock_review(:commented, login), do:  %{ state: "COMMENTED", author: %{ login: login } }
  def mock_review(:request_changes, login), do:  %{ state: "REQUEST_CHANGES", author: %{ login: login } }

end
