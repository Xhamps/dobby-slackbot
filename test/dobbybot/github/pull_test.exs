defmodule Dobbybot.Github.PullTest do
  use ExUnit.Case

  alias Dobbybot.Github.{ Pull, Review }

  test "should get all pull of repo1" do
    pulls = Pull.get_by_repo("repo1")
    assert Enum.count(pulls) == 2
    assert List.first(pulls).id == 11
  end

  test "should get all pull of repo2" do
    pulls = Pull.get_by_repo("repo2")
    assert Enum.count(pulls) == 2
    assert List.first(pulls).id == 21
  end

  test "should add reviews in the Pull" do
    pull = "repo1"
    |> Pull.get_by_repo()
    |> List.first()

    reviews = Review.get_by_pull("1", "repo1")

    assert Pull.add_reviews(reviews, pull).reviews == reviews
  end

  test "should add diff of created_at into the Pull" do
    time = Timex.now
    |> Timex.shift(days: -3)
    |> Timex.format!("{ISO:Extended:Z}")
    pull = %{created_at: time}
    new_pull = Pull.get_diff_created_at(pull)

    assert new_pull.time == "3 dias atrás"
  end

  test "should set not approved if do not have two or more approved" do

    reviews = [%{state: "APPROVED"}]
    pull = %{reviews: reviews}

    new_pull = Pull.is_approved(pull)

    refute new_pull.is_approved
  end

  test "should set approved if have two or more approved" do

    reviews = [%{state: "APPROVED"}, %{state: "APPROVED"}]
    pull = %{reviews: reviews}

    new_pull = Pull.is_approved(pull)

    assert new_pull.is_approved
  end

  test "should set not approved if one approved and one or more unapproded" do

    reviews = [%{state: "APPROVED"}, %{state: "UNAPPROVED"}]
    pull = %{reviews: reviews}

    new_pull = Pull.is_approved(pull)

    refute new_pull.is_approved
  end


  test "should set approved if more than one approved and have unapproded" do

    reviews = [
      %{state: "APPROVED"},
      %{state: "UNAPPROVED"},
      %{state: "APPROVED"}
    ]
    pull = %{reviews: reviews}

    new_pull = Pull.is_approved(pull)

    assert new_pull.is_approved
  end

 end
