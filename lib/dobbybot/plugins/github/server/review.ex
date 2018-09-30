defmodule Dobbybot.Plugins.Github.Server.ReviewServer do
  @moduledoc false

  def is_approved(%{state: "APPROVED"}) do true end
  def is_approved(_) do false end
end
