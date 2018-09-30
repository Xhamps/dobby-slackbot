defmodule  Dobbybot.Plugins.Github.ServerTest do
  use ExUnit.Case

  alias Dobbybot.Plugins.Github.Server

  import Mock

  setup do
    Server.start_link()
    :ok
  end

  test "return all repos" do
    with_mock HTTPoison, [post!: &request_repos/3] do
      repos = Server.get_repos()
        |> case do
            {:ok, data} -> data
            {:error, _error} -> nil
           end

       [repo] = repos

      assert Enum.count(repos) == 1
      assert repo.name == "repos"
    end
  end

  test "return repo by name" do
    with_mock HTTPoison, [post!: &request_repo/3] do
      repo = Server.get_repos()
        |> case do
            {:ok, data} -> data
            {:error, _error} -> nil
          end

      assert repo.name == "repos"
    end
  end

  def request_repos(_request_url, _query, header) do
    header_assert(header)
    
    body = [%{ name: "repos"}];
    
    %{body: Poison.encode!(body), status_code: 200, headers: %{}}
  end


  def request_repo(_request_url, _query, header) do
    header_assert(header)
    
    body = %{ name: "repos"};
    
    %{body: Poison.encode!(body), status_code: 200, headers: %{}}
  end


  def header_assert(header) do
    [auth, accept, contentType] = header

    assert auth == {"Authorization", "token "}
    assert accept == {
      "Accept",
      "application/vnd.github.v4.idl"
    }
    assert contentType ==  {
      "Content-Type",
      "application/x-www-form-urlencoded"
    }
  end

end
