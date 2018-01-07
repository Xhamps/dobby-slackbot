defmodule Dobbybot.Github do

  alias Dobbybot.Github.{Repo, Pull, Review}

  @moduledoc false

  def main do
    get_repos()
    |> Enum.filter(&has_pulls/1)
  end

  def get_repos do
    Repo.get_all
    |> Enum.map(fn (repo) ->
      repo
      |> get_pulls()
      |> Repo.add_pulls(repo)
    end)
  end

  def get_pulls(%{name: name}) do
    name
    |> Pull.get_by_repo()
    |> Enum.map(fn (%{number: number} = pull) ->
      number
      |> Review.get_by_pull(name)
      |> Pull.add_reviews(pull)
    end)
 end

  defp has_pulls(repos) do
    repos
    |> Map.fetch!(:pulls)
    |> (& !Enum.empty?(&1)).()
  end
end
