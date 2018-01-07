defmodule  Dobbybot.Github.Server do
  use GenServer

  @moduledoc false

  @installation_content_type "application/vnd.github.machine-man-preview+json"

  def start_link(opts \\ []) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_repos do
    GenServer.call(__MODULE__, :get_repos)
  end

  def get_pulls(repo) do
    GenServer.call(__MODULE__, {:get_pulls, repo})
  end

  def get_reviews(pull, repo) do
    GenServer.call(__MODULE__, {:get_reviews, repo, pull})
  end

  def handle_call(:get_repos, _from, state) do
    get!("#{site()}/orgs/#{org()}/repos", state)
  end

  def handle_call({:get_pulls, repo }, _from, state) do
    get!("#{site()}/repos/#{org()}/#{repo}2312/pulls", state)
  end

  def handle_call({:get_reviews, repo, pull}, _from, state) do
    get!("#{site()}/repos/#{org()}/#{repo}/pulls/#{pull}/reviews", state)
  end

  defp get!(url, state) do
    url
    |> HTTPoison.get!([
      {"Authorization", "Bearer #{token()}"},
      {"Accept", @installation_content_type}
    ])
    |> case do
      %{body: raw, status_code: 200, headers: _} ->
        {:reply, Poison.decode!(raw, keys: :atoms), state}
      error ->
        IO.inspect(error)
        {:error, error}
    end
  end

  defp site do
    Application.get_env(:dobbybot, :site_github)
  end

  defp token do
    Application.get_env(:dobbybot, :token_github)
  end

  defp org do
    Application.get_env(:dobbybot, :org_github)
  end

end
