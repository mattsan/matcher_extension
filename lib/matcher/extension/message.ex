defmodule Matcher.Extension.Message do
  @moduledoc false

  def format(expression, %{from: from, to: _} = expected, %{from: from, to: _} = actual) do
    IO.chardata_to_string([
      "expected ",
      inspect(expression),
      " to have changed to ",
      inspect(expected.to),
      ", but is now ",
      inspect(actual.to)
    ])
  end

  def format(expression, %{from: _, to: _} = expected, %{from: _, to: _} = actual) do
    IO.chardata_to_string([
      "expected ",
      inspect(expression),
      " to have initially been ",
      inspect(expected.from),
      ", but was ",
      inspect(actual.from)
    ])
  end

  def format(expression, %{to: _} = expected, %{to: _} = actual) do
    IO.chardata_to_string([
      "expected ",
      inspect(expression),
      " to have changed to ",
      inspect(expected.to),
      ", but is now ",
      inspect(actual.to)
    ])
  end

  def format(expression, %{by: _} = expected, %{by: _} = actual) do
    IO.chardata_to_string([
      "expected ",
      inspect(expression),
      " to have changed by ",
      inspect(expected.by),
      ", but was changed by ",
      inspect(actual.by)
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
