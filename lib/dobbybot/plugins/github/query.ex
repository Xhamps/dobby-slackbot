defmodule Dobbybot.Plugins.Github.Query do
  @moduledoc false

  def get_repos() do
    ~s"""
    query { organization(login: \\\"#{org()}\\\") { repositories(first: 100) { nodes {
            name,
            pullRequests(first: 30, states: OPEN) {
              nodes {
                title,
                url,
                state,
                createdAt,
                reviews(first: 10) {
                  nodes {
                    state,
                    author {
                      login,
                      avatarUrl
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    """
    |> String.replace("\r", "")
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.join(" ")
  end

  def get_repo(repo) do
    ~s"""
    query {
      repository(owner: \\\"#{org()}\\\", name: \\\"#{repo}\\\") {
        name,
        pullRequests(first: 30, states: OPEN) {
          nodes {
            title,
            url,
            state,
            createdAt,
            reviews(first: 10) {
              nodes {
                state,
                author {
                  login,
                  avatarUrl
                }
              }
            }
          }
        }
      }
    }
    """
    |> String.replace("\r", "")
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.join(" ")
  end

  defp org do
    Application.get_env(:dobbybot, :org_github, "elixir-lang")
  end

end
