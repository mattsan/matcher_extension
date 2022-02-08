defmodule Matcher.Extension.MessageTest do
  use ExUnit.Case, async: true

  alias Matcher.Extension.Message

  doctest Message

  test "has_changed_error from: to:" do
    assert ~S(expected "expression" not to have changed, but did change from "from" to "to") ==
             Message.has_changed_error("expression", from: "from", to: "to")
  end

  test "initial_value_error exptected: actual:" do
    assert ~S(expected "expression" to have initially been "expected", but was "actual") ==
             Message.initial_value_error("expression", expected: "expected", actual: "actual")
  end

  test "unexpected_change_error to: actual:" do
    assert ~S(expected "expression" to have changed to "to", but is now "actual") ==
             Message.unexpected_change_error("expression", to: "to", actual: "actual")
  end

  test "unexpected_change_error by: actual:" do
    assert ~S(expected "expression" to have changed by "by", but was changed by "actual") ==
             Message.unexpected_change_error("expression", by: "by", actual: "actual")
  end

  test "has_not_changed_error from:" do
    assert ~S(expected "expression" to have changed from "from", but did not change) ==
             Message.has_not_changed_error("expression", from: "from")
  end

  test "has_not_changed_error to:" do
    assert ~S(expected "expression" to have changed to "to", but did not change) ==
             Message.has_not_changed_error("expression", to: "to")
  end

  test "has_not_changed_error from: to:" do
    assert ~S(expected "expression" to have changed from "from" to "to", but did not change) ==
             Message.has_not_changed_error("expression", from: "from", to: "to")
  end
end
