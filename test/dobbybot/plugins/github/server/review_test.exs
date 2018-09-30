defmodule Dobbybot.Plugins.Github.Server.ReviewServerTest do
  use ExUnit.Case

  alias Dobbybot.Plugins.Github.Server.ReviewServer

  test "return true if Pull have the state with 'APPROVED'" do
    assert ReviewServer.is_approved(%{state: "APPROVED"})
  end

  test "return true if Pull have the state different than 'APPROVED'" do
    refute ReviewServer.is_approved(%{state: "UNAPPROVED"})
  end

  test "return false if do not passing Pull" do
    refute ReviewServer.is_approved([])
  end
end
