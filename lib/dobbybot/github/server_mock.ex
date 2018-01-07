defmodule  Dobbybot.Github.ServerMock do
  use GenServer

  @moduledoc false

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
    {:reply, [%{
      id: 1,
      name: "repo1",
      html_url: "https://github.com/dobbybot/repo1",
      description: "Repo test 1",
      created_at: "2017-12-19T19:40:29Z",
    },
    %{
      id: 2,
      name: "repo2",
      html_url: "https://github.com/dobbybot/repo2",
      description: "Repo test 2",
        created_at: "2017-12-31T19:40:29Z",
    }],
    state }
  end

  def handle_call({:get_pulls, "repo1" }, _from, state) do
    {:reply, [%{
      id: 11,
      number: 11,
      title: "PR 1 repo1",
      created_at: "2017-12-19T19:40:29Z",
    },
    %{
      id: 12,
      number: 12,
      title: "PR 2 repo1",
      created_at: "2017-12-31T19:40:29Z",
    }],
    state }
  end

  def handle_call({:get_pulls, "repo2" }, _from, state) do
    { :reply,
      [%{
        id: 21,
        number: 21,
        title: "PR 1 repo2",
        created_at: "2018-01-01T09:40:29Z",
      },
      %{
        id: 22,
        number: 22,
        title: "PR 2 repo2",
        created_at: "2017-12-30T12:40:29Z",
      }],
      state
    }
  end

  def handle_call({:get_pulls, _}, _from, state) do
    {:error, state}
  end

  def handle_call({:get_reviews, repo, pull}, _from, state) do
    {:reply, [%{
      id: 111,
      user: %{
        login: 'user 1',
        id: 666
      },
      state: "APPROVED"
    }],
      state }
  end
end
