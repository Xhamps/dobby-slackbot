defmodule DobbybotTest do
  use ExUnit.Case
  doctest Dobbybot

  test "greets the world" do
    assert Dobbybot.hello() == :world
  end
end
