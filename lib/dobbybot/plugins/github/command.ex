defmodule Dobbybot.Plugins.Github.Command do
  @moduledoc false

  @commands [
    %{ action: "prs", description: "Show all PRs of all repositories", validation: ~r/prs$/ },
    %{ action: "prs_repository", description: "Show all PRs of the repository selected", validation: ~r/prs?\s(.*)$/ }
  ]

  alias Dobbybot.Plugins.Github.Server.RepoServer
  alias Dobbybot.Plugins.Github.Message.Repos

  def commands, do: @commands

  def run("prs", _command) do
    RepoServer.get_all()
    |> parse_repos()
  end

  def run("prs_repository", [_command, repo]) do
    RepoServer.get(repo)
    |> parse_repo(repo)
  end

  def parse_repos({:error, _error}) do
    %{ text: "Bad Dobby! Bad Dobby! Dobby can't do this, sir"}
  end
  def parse_repos({:ok, data }) do
    data
    |> RepoServer.parse()
    |> Enum.filter(fn repo -> length(repo.pullRequests) > 0 end)
    |> Repos.parse()
    |> case do
         [] -> %{ text: "Sorry, your repositories don't have Pull Request"}
         data -> data
       end

  end

  def parse_repo({:error, _error}, repo), do: %{ text: "Dobby will have to punish. Dobby didn't found the repository #{repo}" }
  def parse_repo({:ok, data}, _repo) do
    data
    |> RepoServer.parse()
    |> Enum.filter(fn repo -> length(repo.pullRequests) > 0 end)
    |> Repos.parse()
    |> case do
         [] -> %{ text: "Sorry, your repository don't have Pull Request"}
         data -> data
       end

  end

end
