defmodule Matcher.Extension.MessageTest do
  use ExUnit.Case, async: true

  alias Matcher.Extension.Message

  doctest Message

  test "from" do
    assert ~S(expected "++i" to have initially been 1, but was 0) == Message.format("++i", %{from: 1}, %{from: 0})
  end

  test "from/to" do
    assert ~S(expected "++i" to have changed to 2, but is now 1) == Message.format("++i", %{from: 0, to: 2}, %{from: 0, to: 1})
  end

  test "to" do
    assert ~S(expected "++i" to have changed to 1, but is now 0) == Message.format("++i", %{to: 1}, %{to: 0})
  end

  test "by" do
    assert ~S(expected "++i" to have changed by 1, but was changed by 0) == Message.format("++i", %{by: 1}, %{by: 0})
  end

  test "others" do
    assert ~S(expected "++i" not to have changed, but did change from 1 to 0) == Message.format("++i", 1, 0)
  end
end
