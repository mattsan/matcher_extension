defmodule Matcher.Extension.Message do
  @moduledoc false

  def format(expression, %{from: expected}, %{from: actual}) when expected != actual do
    IO.chardata_to_string([
      "expected ",
      inspect(expression),
      " to have initially been ",
      inspect(expected),
      ", but was ",
      inspect(actual)
    ])
  end

  def format(expression, %{to: expected}, %{to: actual}) do
    IO.chardata_to_string([
      "expected ",
      inspect(expression),
      " to have changed to ",
      inspect(expected),
      ", but is now ",
      inspect(actual)
    ])
  end

  def format(expression, %{by: expected}, %{by: actual}) do
    IO.chardata_to_string([
      "expected ",
      inspect(expression),
      " to have changed by ",
      inspect(expected),
      ", but was changed by ",
      inspect(actual)
    ])
  end

  def format(expression, expected, actual) do
    IO.chardata_to_string([
      "expected ",
      inspect(expression),
      " not to have changed, but did change from ",
      inspect(expected),
      " to ",
      inspect(actual)
    ])
  end
end
