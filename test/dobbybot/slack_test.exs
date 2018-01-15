defmodule Dobbybot.SlackTest do
  use ExUnit.Case

  alias Dobbybot.Slack, as: DSlack
  alias Dobbybot.Slack.Responses.PRs
  alias Slack.Sends

  import Mock
  import ExUnit.CaptureIO

  test "return tuple of ok when is connected" do
    state = %{state: :ok}
    slack = %{me: %{id: 1, name: "Dobbybot"}}
    log = capture_io(fn ->
      assert {:ok, state} == DSlack.handle_connect(slack, state)
    end)

    assert log == "Connected as Dobbybot\n"
  end

  test "send the message when the message was sended is ping" do
    state = %{state: :ok}
    slack = %{me: %{id: 1, name: "Dobbybot"}}
    message = %{
      type: "message",
      user: "123456",
      channel: "slack",
      text: "<@1> ping"
    }
    mock = %{
      message: "<@#{message.user}> pong",
      channel: message.channel,
      slack: slack
    }

    with_mock Sends, [send_message: & send_message_pong(&1, &2, &3, mock)] do
      assert {:ok, state} == DSlack.handle_event(message, slack, state)
    end
  end

  test "parse and send the message when the message was sended is prs" do
    state = %{state: :ok}
    slack = %{me: %{id: 1, name: "Dobbybot"}}
    message = %{
      type: "message",
      user: "123456",
      channle: "slack",
      text: "<@1> prs"
    }

    with_mock PRs, [run: & prs_run(&1, message)] do
      assert {:ok, state} == DSlack.handle_event(message, slack, state)
    end
  end

  test "return tuple of ok when the type is not 'message'" do
    state = %{state: :ok}
    message = %{type: "another"}

    assert {:ok, state} == DSlack.handle_event(message, %{}, state)
  end

  test "return tuple of ok when receive message of type 'message'" do
    state = %{state: :ok}
    message = %{type: "message"}

    assert {:ok, state} == DSlack.handle_message(message, %{}, state)
  end

  test "return tuple of ok when receive message of anothe type" do
    state = %{state: :ok}
    message = %{type: "another"}

    assert {:ok, state} == DSlack.handle_message(message, %{}, state)
  end

  test "return tuple of ok and message when receive info of message type" do
    state = %{state: :ok}
    message = {1, "Hello", "channel"}
    slack = %{me: %{id: 1, name: "Dobbybot"}}
    mock = %{
      text: "Hello",
      channel: "channel",
      slack: slack
    }

    with_mock Sends, [send_message: & send_message_info(&1, &2, &3, mock)] do
      log = capture_io(fn ->
        assert {:ok, state} == DSlack.handle_info(message, slack, state)
      end)

      assert log == "Sending your message, captain!\n"
    end
  end

  test "return tuple of ok when receive info of anothe type" do
    state = %{state: :ok}

    assert {:ok, state} == DSlack.handle_info(%{}, %{}, state)
  end

  def prs_run(message, mock) do
    assert message == mock
  end

  def send_message_pong(message, channel, slack, mock) do
    assert message == mock.message
    assert channel == mock.channel
    assert slack == mock.slack
  end

  def send_message_info(text, channel, slack,  mock) do
    assert text == mock.text
    assert channel == mock.channel
    assert slack == mock.slack
  end
end
