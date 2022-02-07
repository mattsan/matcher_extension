defmodule Matcher.Extension.MessageTest do
  use ExUnit.Case, async: true

  alias Matcher.Extension.Message

  doctest Message

  test "initializing_error/3" do
    assert ~S(expected "expression" to have initially been "expected", but was "actual") ==
             Message.initializing_error("expression", expected: "expected", actual: "actual")
  end

  test "changed_error/3" do
    assert ~S(expected "expression" not to have changed, but did change from "expected" to "actual") ==
             Message.changed_error("expression", expected: "expected", actual: "actual")
  end

  test "unchanged_error/2 from" do
    assert ~S(expected "expression" to have changed from "from", but did not change) ==
             Message.unchanged_error("expression", from: "from")
  end

  test "invalid_change_error/3 to" do
    assert ~S(expected "expression" to have changed to "expected", but is now "actual") ==
             Message.invalid_change_error("expression", to: "expected", actual: "actual")
  end

  test "invalid_change_error/3 by" do
    assert ~S(expected "expression" to have changed by "expected", but was changed by "actual") ==
             Message.invalid_change_error("expression", by: "expected", actual: "actual")
  end

  test "unchanged_error/3" do
    assert ~S(expected "expression" to have changed from "expected" to "actual", but did not change) ==
             Message.unchanged_error("expression", expected: "expected", actual: "actual")
  end

  test "unchanged_error/2 to" do
    assert ~S(expected "expression" to have changed to "to", but did not change) ==
             Message.unchanged_error("expression", to: "to")
  end
end
