defmodule Matcher.Extension.Message do
  @moduledoc false

  def has_changed_error(expression, from: from, to: to) do
    "expected #{inspect(expression)} not to have changed, but did change from #{inspect(from)} to #{inspect(to)}"
  end

  def initial_value_error(expression, expected: expected, actual: actual) do
    "expected #{inspect(expression)} to have initially been #{inspect(expected)}, but was #{inspect(actual)}"
  end

  def unexpected_change_error(expression, to: expected, actual: actual) do
    "expected #{inspect(expression)} to have changed to #{inspect(expected)}, but is now #{inspect(actual)}"
  end

  def unexpected_change_error(expression, by: expected, actual: actual) do
    "expected #{inspect(expression)} to have changed by #{inspect(expected)}, but was changed by #{inspect(actual)}"
  end

  def has_not_changed_error(expression, from: from) do
    "expected #{inspect(expression)} to have changed from #{inspect(from)}, but did not change"
  end

  def has_not_changed_error(expression, to: to) do
    "expected #{inspect(expression)} to have changed to #{inspect(to)}, but did not change"
  end

  def has_not_changed_error(expression, from: from, to: to) do
    "expected #{inspect(expression)} to have changed from #{inspect(from)} to #{inspect(to)}, but did not change"
  end
end
