defmodule Matcher.Extension.Message do
  @moduledoc false

  def format(expression, expected, actual) do
    iodata =
      case {expected, actual} do
        {%{from: expected}, %{from: actual}} when expected != actual ->
          [
            [" to have initially been ", expected],
            [", but was ", actual]
          ]

        {%{to: expected}, %{to: actual}} ->
          [
            [" to have changed to ", expected],
            [", but is now ", actual]
          ]

        {%{by: expected}, %{by: actual}} ->
          [
            [" to have changed by ", expected],
            [", but was changed by ", actual]
          ]

        {expected, actual} ->
          [
            [" not to have changed, but did change from ", expected],
            [" to ", actual]
          ]
      end
      |> Enum.map(fn [first, second] -> [first, inspect(second)] end)

    IO.iodata_to_binary([["expected ", inspect(expression)], iodata])
  end
end
