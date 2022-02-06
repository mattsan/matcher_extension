defmodule Matcher.Extension.MessageTest do
  use ExUnit.Case, async: true

  alias Matcher.Extension.Message

  doctest Message

  test "message1" do
    assert ~S(expected "expression" to have initially been "expected", but was "actual") ==
             Message.message1("expression", "expected", "actual")
  end

  test "message2" do
    assert ~S(expected "expression" not to have changed, but did change from "expected" to "actual") ==
             Message.message2("expression", "expected", "actual")
  end

  test "message3" do
    assert ~S(expected "expression" to have changed from "from", but did not change) ==
             Message.message3("expression", "from")
  end

  test "message4" do
    assert ~S(expected "expression" to have changed to "expected", but is now "actual") ==
             Message.message4("expression", "expected", "actual")
  end

  test "message5" do
    assert ~S(expected "expression" to have changed by "expected", but was changed by "actual") ==
             Message.message5("expression", "expected", "actual")
  end

  test "message6" do
    assert ~S(expected "expression" to have changed from "from" to "to", but did not change) ==
             Message.message6("expression", "from", "to")
  end
end
