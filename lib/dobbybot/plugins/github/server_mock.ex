defmodule  Dobbybot.Plugins.Github.ServerMock do
  use GenServer

  @moduledoc false

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
    data = %{
      data: %{
        organization: %{
          repositories: %{
            nodes: [
              repo(:empty, "repo-not-prs"),
              repo(:repo, "repo-with-prs")
            ]
          }
        }
      }
    }
    {:reply, {:ok, data}, state }
  end

  def handle_call({:get_repo, 'error'}, _from, state), do: {:reply, {:error, %{ message: "Server error"}}, state}
  def handle_call({:get_repo, name}, _from, state) do
    data = %{
      data: %{
        repository: repo(:repo, name)
      }
    }
    {:reply, {:ok, data}, state }
  end

  def handle_call({:get_pulls, _}, _from, state) do
    {:error, state}
  end


  def repo(:empty, name), do: %{name: name, pullRequests: %{nodes: []}}
  def repo(:repo, name) do
    %{
      name: name,
      pullRequests: %{
        nodes: [
          pr(:empty, 1),
          pr(:approved, 2),
          pr(:noApproved, 3)
        ]
      }
    }
  end

  def pr(:empty, number) do
    %{
      createdAt: "2018-09-27T13:26:15Z",
      reviews: %{nodes: []},
      state: "OPEN",
      title: "Pull Request " <>  to_string(number),
      url: "https://github.com/xhamps/dobbybot/pull/" <> to_string(number)
    }
  end

  def pr(:approved, number) do
    %{
      createdAt: "2018-09-27T13:26:15Z",
      reviews: %{
        nodes: [
          review(:approved, "user1"),
          review(:approved, "user2"),
        ]
      },
      state: "OPEN",
      title: "Pull Request " <> to_string(number),
      url: "https://github.com/xhamps/dobbybot/pull/" <> to_string(number)
    }
  end

  def pr(:noApproved, number) do
    %{
      createdAt: "2018-09-27T13:26:15Z",
      reviews: %{
        nodes: [
          review(:approved, "user1"),
          review(:commented, "user2")
        ]
      },
      state: "OPEN",
      title: "Pull Request " <> to_string(number),
      url: "https://github.com/xhamps/dobbybot/pull/" <> to_string(number)
    }
  end

  def review(:approved, user) do
    %{
        author: %{
          login: user
        },
        state: "APPROVED"
    }
  end

  def review(:commented, user) do
    %{
      author: %{
        login: user
      },
      state: "COMMENTED"
    }
  end
end
