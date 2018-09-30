defmodule Dobbybot.Plugins.Github.Message.Reviews do
  @moduledoc false

  def parse(reviews) do
    reviews
    |> Enum.map(&mapper_text/1)
    |> Enum.join(" - ")
  end

  def mapper_text(%{state: state, author: %{ login: login }}) do
    "#{msg_icon(state)} #{login}"
  end

  def msg_icon(state = "APPROVED"), do: ":white_check_mark:"
  def msg_icon(state = "COMMENTED"), do: ":question:"
  def msg_icon(_state), do: ":no_entry_sign:"
end
