defmodule Dobbybot.Github.Repo do

  @moduledoc false

  @server Application.get_env(:dobbybot, :server_github)

  def get_all do
    @server.get_repos()
  end

  def add_pulls(pulls, repo) do
    repo
    |> Map.put(:pulls, pulls)
  end
end
