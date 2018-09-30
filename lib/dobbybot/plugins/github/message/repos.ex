defmodule Dobbybot.Plugins.Github.Message.Repos do
  @moduledoc false

  alias Dobbybot.Plugins.Github.Message.PRs

  def parse(repos) do
    repos
    |> Enum.map(&mapper/1)
  end

  def mapper (%{pullRequests: pulls, name: full_name}) do
    %{
      text: "[#{full_name}]",
      attachments: pulls |> PRs.parse
    }
  end
end
