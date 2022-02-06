defmodule Matcher.Extension.Message do
  @moduledoc false

  require EEx

  EEx.function_from_string(
    :defp,
    :error_message1,
    "expected <%= expression %> to have initially been <%= expected %>, but was <%= actual %>",
    [:expression, :expected, :actual]
  )

  EEx.function_from_string(
    :defp,
    :error_message2,
    "expected <%= expression %> not to have changed, but did change from <%= expected %> to <%= actual %>",
    [:expression, :expected, :actual]
  )

  EEx.function_from_string(
    :defp,
    :error_message3,
    "expected <%= expression %> to have changed from <%= from %>, but did not change",
    [:expression, :from]
  )

  EEx.function_from_string(
    :defp,
    :error_message4,
    "expected <%= expression %> to have changed to <%= expected %>, but is now <%= actual %>",
    [:expression, :expected, :actual]
  )

  EEx.function_from_string(
    :defp,
    :error_message5,
    "expected <%= expression %> to have changed by <%= expected %>, but was changed by <%= actual %>",
    [:expression, :expected, :actual]
  )

  EEx.function_from_string(
    :defp,
    :error_message6,
    "expected <%= expression %> to have changed from <%= from %> to <%= to %>, but did not change",
    [:expression, :from, :to]
  )

  def message1(expression, expected, actual) do
    error_message1(inspect(expression), inspect(expected), inspect(actual))
  end

  def message2(expression, expected, actual) do
    error_message2(inspect(expression), inspect(expected), inspect(actual))
  end

  def message3(expression, from) do
    error_message3(inspect(expression), inspect(from))
  end

  def message4(expression, expected, actual) do
    error_message4(inspect(expression), inspect(expected), inspect(actual))
  end

  def message5(expression, expected, actual) do
    error_message5(inspect(expression), inspect(expected), inspect(actual))
  end

  def message6(expression, from, to) do
    error_message6(inspect(expression), inspect(from), inspect(to))
  end
end
