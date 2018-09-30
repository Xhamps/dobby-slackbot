defmodule Dobbybot.Plugins.Github.Server.PullServerTest do
  use ExUnit.Case

  alias Dobbybot.Plugins.Github.Server.PullServer

  test "parse the data whem comes of service" do
    time = Timex.now
    |> Timex.shift(days: -3)
    |> Timex.format!("{ISO:Extended:Z}")

    pull = %{
      reviews: %{
        nodes: [
          %{ state: "APPROVED", time: time},
          %{ state: "UNAPPROVED", time: time}
        ]
      },
      createdAt: time
    }

    new_pull = PullServer.parse(pull)

    assert new_pull[:time] == "3 dias atrás"
    refute new_pull[:is_approved]
  end

  test "get data of the reviews" do
    pull = %{reviews: %{ nodes: "reviews"}}

    assert PullServer.get_reviews(pull) == "reviews"
  end

  test "add diff of created_at into the Pull" do
    time = Timex.now
    |> Timex.shift(days: -3)
    |> Timex.format!("{ISO:Extended:Z}")
    pull = %{createdAt: time}
    new_pull = PullServer.get_diff_created_at(pull)

    assert new_pull.time == "3 dias atrás"
  end

  test "set unapproved if do not have two or more approved" do
    reviews = [%{state: "APPROVED"}]
    pull = %{reviews: reviews}

    new_pull = PullServer.is_approved(pull)

    refute new_pull.is_approved
  end

  test "set approved if have two or more approved" do
    reviews = [%{state: "APPROVED"}, %{state: "APPROVED"}]
    pull = %{reviews: reviews}

    new_pull = PullServer.is_approved(pull)

    assert new_pull.is_approved
  end

  test "set unapproved if one approved and one or more unapproded" do
    reviews = [%{state: "APPROVED"}, %{state: "UNAPPROVED"}]
    pull = %{reviews: reviews}

    new_pull = PullServer.is_approved(pull)

    refute new_pull.is_approved
  end

  test "set approved if more than one approved and have unapproded" do
    reviews = [
      %{state: "APPROVED"},
      %{state: "UNAPPROVED"},
      %{state: "APPROVED"}
    ]
    pull = %{reviews: reviews}

    new_pull = PullServer.is_approved(pull)

    assert new_pull.is_approved
  end
 end
