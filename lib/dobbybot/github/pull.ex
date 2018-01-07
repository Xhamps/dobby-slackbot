defmodule Dobbybot.Github.Pull do
  alias __MODULE__

  alias Dobbybot.Github.Review

  @moduledoc false

  @server Application.get_env(:dobbybot, :server_github)

  def get_by_repo(name) do
    name
    |> @server.get_pulls()
    |> Enum.map(fn (pull) ->
      pull
      |> get_diff_created_at()
    end)
  end

  def add_reviews(reviews, pull) do
    pull
    |> Map.put(:reviews, reviews)
    |> is_approved()
  end

  def get_diff_created_at(%{created_at: created_at} = pull) do
    {:ok, time} = created_at
                  |> Timex.parse!("{ISO:Extended:Z}")
                  |> Timex.format("{relative}", :relative)
    Map.put(pull, :time, time)
  end

  def is_approved(%{reviews: reviews} = pull) do
    approved = reviews
    |> Enum.filter(&Review.is_approved/1)
    |> Enum.count()
    |> (fn count -> count > 1 end).()

    Map.put(pull, :is_approved, approved)
  end
end
