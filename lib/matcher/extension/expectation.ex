defmodule Matcher.Extension.Expectation do
  @moduledoc """
  Add Expectations.

  ## Examples

  ```elixir
  # prepare test target functions

  def put_value(pid, key, value) do
    Agent.update(pid, &Map.put(&1, key, value))
  end

  def get_value(pid, key) do
    Agent.get(pid, &Map.get(&1, key))
  end

  setup do
    {:ok, pid} = start_supervised({Agent, fn -> %{hoge: 0} end})

    [pid: pid]
  end
  ```
  """

  @self_diagnosis System.get_env("MATCHER_EXTENSION_SELF_DIAGNOSIS") == "1"

  @doc false
  defmacro assert_result(expression_string, expected, actual) do
    if @self_diagnosis do
      quote bind_quoted: [expression_string: expression_string, expected: expected, actual: actual] do
        %{expression: expression_string, expected: expected, actual: actual}
      end
    else
      quote bind_quoted: [expression_string: expression_string, expected: expected, actual: actual] do
        assert expected == actual, Matcher.Extension.Message.format(expression_string, expected, actual)
      end
    end
  end

  @doc """
  Expects not to change.

  ## Examples

  ```elixir
  test "not to change", %{pid: pid} do
    expect put_value(pid, :foo, 0), not_to_change(get_value(pid, :foo))
  end
  ```
  """
  defmacro expect(operation, expression)

  defmacro expect(operation, {:not_to_change, _, [expression]}) do
    expression_string = Macro.to_string(expression)

    quote do
      expected = unquote(expression)
      unquote(operation)
      actual = unquote(expression)

      assert_result(unquote(expression_string), expected, actual)
    end
  end

  @doc """
  Expects to change, or not_to change

  ## Examples

  ```elixir
  test "to change by", %{pid: pid} do
    expect put_value(pid, :foo, 1), to_change(get_value(pid, :foo)), by(1)
  end

  test "to change to", %{pid: pid} do
    expect put_value(pid, :foo, 1), to_change(get_value(pid, :foo)), to(1)
  end

  test "not to change from", %{pid: pid} do
    expect put_value(pid, :foo, 0), not_to_change(get_value(pid, :foo)), from(0)
  end
  ```
  """
  defmacro expect(operation, expression, from_or_by_or_to)

  defmacro expect(operation, {:not_to_change, _, [expression]}, {:from, _, [expected]}) do
    expression_string = Macro.to_string(expression)

    quote do
      unquote(expression)
      unquote(operation)
      actual = unquote(expression)

      expected = %{from: unquote(expected)}
      actual = %{from: actual}

      assert_result(unquote(expression_string), expected, actual)
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

      assert_result(unquote(expression_string), expected, actual)
    end
  end

  defmacro expect(operation, {:to_change, _, [expression]}, {:to, _, [expected]}) do
    expression_string = Macro.to_string(expression)

    quote do
      unquote(expression)
      unquote(operation)
      actual = unquote(expression)

      expected = %{to: unquote(expected)}
      actual = %{to: actual}

      assert_result(unquote(expression_string), expected, actual)
    end
  end

  @doc """
  Expects to change.

  ## Examples

  ```elixir
  test "to change from to", %{pid: pid} do
    expect put_value(pid, :foo, 1), to_change(get_value(pid, :foo)), from(0), to(1)
  end
  """
  defmacro expect(operation, expression, from, to)

  defmacro expect(operation, {:to_change, _, [expression]}, {:from, _, [expected1]}, {:to, _, [expected2]}) do
    expression_string = Macro.to_string(expression)

    quote do
      actual1 = unquote(expression)
      unquote(operation)
      actual2 = unquote(expression)

      expected = %{from: unquote(expected1), to: unquote(expected2)}
      actual = %{from: actual1, to: actual2}

      assert_result(unquote(expression_string), expected, actual)
    end
  end
end
