defmodule Dobbybot.Plugins.Github.Server do
  use GenServer

  @moduledoc false

  @graphql_content_type "application/vnd.github.v4.idl"

  alias Dobbybot.Plugins.Github.Query

  def init(args) do
    {:ok, args}
  end

  def start_link(opts \\ []) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_repos do
    GenServer.call(__MODULE__, :get_repos)
  end

  def get_repo(repo) do
    GenServer.call(__MODULE__, {:get_repo, repo})
  end

  def handle_call(:get_repos, _from, state) do
    Query.get_repos()
    |> post!(state)
  end

  def handle_call({:get_repo, repo }, _from, state) do
    repo
    |> Query.get_repo()
    |> post!(state)
  end

  defp post!(query, state) do
    "#{url()}/graphql"
    |> HTTPoison.post!("{\"query\": \"#{query}\"}",[
          {"Authorization", "token #{token()}"},
          {"Accept", @graphql_content_type},
          {"Content-Type", "application/x-www-form-urlencoded"}
        ])
        |> case do
             %{body: raw, status_code: 200, headers: _} ->
               {:reply, {:ok, Poison.decode!(raw, keys: :atoms) }, state}
             %HTTPoison.Response{ body: raw } ->
               {:reply, {:error, Poison.decode!(raw, keys: :atoms) }, state}
           end
  end

  defp url do
    Application.get_env(:dobbybot, :site_github, "https://api.github.com")
  end

  defp token do
    Application.get_env(:dobbybot, :token_github)
  end
end

