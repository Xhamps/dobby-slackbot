defmodule Dobbybot.Github.ReviewTest do
  use ExUnit.Case

  alias Dobbybot.Github.Review

  test "get all review" do
    reviews = Review.get_by_pull(1, "test_repo")
    assert Enum.count(reviews) == 1
    assert List.first(reviews).id == 111
  end

  test "return true if Pull have the state with 'APPROVED'" do
    assert Review.is_approved(%{state: "APPROVED"})
  end

  test "return true if Pull have the state different than 'APPROVED'" do
    refute Review.is_approved(%{state: "UNAPPROVED"})
  end

  test "return false if do not passing Pull" do
    refute Review.is_approved([])
  end
end
