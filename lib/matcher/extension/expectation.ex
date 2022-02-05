defmodule Matcher.Extension.Expectation do
  defmacro expect(operation, {:to_change, _, [expression]}, {:to, _, [expected]}) do
    expression_string = Macro.to_string(expression)

    quote do
      unquote(expression)
      unquote(operation)
      actual = unquote(expression)

      expected = %{to: unquote(expected)}
      actual = %{to: actual}

      assert expected == actual, Matcher.Extension.Message.format(unquote(expression_string), expected, actual)
    end
  end

  defmacro expect(operation, {:to_change, _, [expression]}, {:from, _, [expected1]}, {:to, _, [expected2]}) do
    expression_string = Macro.to_string(expression)

    quote do
      actual1 = unquote(expression)
      unquote(operation)
      actual2 = unquote(expression)

      expected = %{from: unquote(expected1), to: unquote(expected2)}
      actual = %{from: actual1, to: actual2}

      assert expected == actual, Matcher.Extension.Message.format(unquote(expression_string), expected, actual)
    end
  end

  defmacro expect(operation, {:to_change, _, [expression]}, {:by, _, [expected]}) do
    expression_string = Macro.to_string(expression)

    quote do
      actual1 = unquote(expression)
      unquote(operation)
      actual2 = unquote(expression)

      expected = %{by: unquote(expected)}
      actual = %{by: actual2 - actual1}

      assert expected == actual, Matcher.Extension.Message.format(unquote(expression_string), expected, actual)
    end
  end

  defmacro expect(operation, {:not_to_change, _, [expression]}) do
    expression_string = Macro.to_string(expression)

    quote do
      expected = unquote(expression)
      unquote(operation)
      actual = unquote(expression)

      assert expected == actual, Matcher.Extension.Message.format(unquote(expression_string), expected, actual)
    end
  end
end
