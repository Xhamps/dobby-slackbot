defmodule Dobbybot.Plugins.Github.Server.RepoServer do
  @moduledoc false

  @server Application.get_env(:dobbybot, :server_github)

  alias Dobbybot.Plugins.Github.Server.PullServer

  def get(name) do
    @server.get_repo(name)
    |> response_get()
  end

  defp response_get(error = {:error, _error}), do: error
  defp response_get({:ok, data}) do
    data
    |> get_in([:data, :repository])
    |>(& {:ok, [&1]}).()
  end

  def get_all do
    @server.get_repos()
    |> response_get_all()
  end

  defp response_get_all(error = {:error, _error}), do: error
  defp response_get_all({:ok, data}) do
    data
    |> get_in([:data, :organization, :repositories, :nodes])
    |>(& {:ok, &1}).()
  end

  def parse(repos) do
    repos
    |> Enum.map(& Map.put(&1, :pullRequests, get_pulls(&1)))
  end

  def get_pulls(repo) do
    repo
    |> get_in([:pullRequests, :nodes])
    |> Enum.map(& PullServer.parse(&1))
  end
end
