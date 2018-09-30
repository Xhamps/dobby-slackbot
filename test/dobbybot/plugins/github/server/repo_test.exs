defmodule Dobbybot.Plugins.Github.Server.RepoServerTest do
  use ExUnit.Case

  alias Dobbybot.Plugins.Github.Server.RepoServer

  test "return all repos" do
    repos = RepoServer.get_all()
    |> case do
         {:ok, data} -> data
         {:error, _error} -> nil 
       end

    assert Enum.count(repos) == 2
  end

  test "return repo by name" do
    repo = RepoServer.get('dobbybot')
    |> case do
         {:ok, data} -> List.first(data)
         {:error, _error} -> nil 
       end

    assert repo[:name] == 'dobbybot'
    assert length(repo[:pullRequests][:nodes]) == 3
  end
  

  test "return error when didn't find the repo" do
    error = RepoServer.get('error')
    |> case do
         {:ok, _data} -> nil
         {:error, error} -> error 
       end

    assert error[:message] == "Server error"
  end
end
