defmodule Dobbybot.Plugins.Github.Server.PullServer do
  @moduledoc false

  alias Dobbybot.Plugins.Github.Server.ReviewServer

  def parse(pulls) do
    pulls
    |> (& Map.put(&1, :reviews, get_reviews(&1))).()
    |> get_diff_created_at()
    |> is_approved()
  end

  def get_reviews(pull), do: get_in(pull, [:reviews, :nodes])

  def get_diff_created_at(%{createdAt: created_at} = pull) do
    {:ok, time} = created_at
                  |> Timex.parse!("{ISO:Extended:Z}")
                  |> Timex.format("{relative}", :relative)
    Map.put(pull, :time, time)
  end

  def is_approved(%{reviews: reviews} = pull) do
    approved = reviews
    |> Enum.filter(&ReviewServer.is_approved/1)
    |> Enum.count()
    |> (fn count -> count > 1 end).()

    Map.put(pull, :is_approved, approved)
  end
end
