defmodule Dobbybot.Github.Review do

  @moduledoc false

  @server Application.get_env(:dobbybot, :server_github)

  def get_by_pull(number_pull, name_repo) do
    @server.get_reviews(number_pull, name_repo)
  end

  def is_approved(%{state: "APPROVED"}) do true end
  def is_approved(_) do false end
end
