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

  ## Formatter

  If you don't want that the formatter puts arguments of `expect/2`, `expect/3` and `expect/4` in parentheses,
  you can add options to `.formatter.exs`.

  ```elixir
  [
    locals_without_parens: [expect: 2, expect: 3, expect: 4] # add this line
  ]
  ```

  or

  ```elixir
  [
    import_deps: [:matcher_extension] # add this line
  ]
  ```
  """

  import Matcher.Extension.Message

  @self_diagnosis System.get_env("MATCHER_EXTENSION_SELF_DIAGNOSIS") == "1"

  @doc false
  defmacro eval_result(result)

  defmacro eval_result(result) do
    if @self_diagnosis do
      quote do
        unquote(result)
      end
    else
      quote do
        case unquote(result) do
          {:error, message} ->
            flunk(message)

          _ ->
            true
        end
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

      case unquote(expression) do
        ^expected ->
          :ok

        actual ->
          {:error, message2(unquote(expression_string), expected, actual)}
      end
      |> eval_result()
    end
  end

  @doc """
  Expects to change, or not_to change

  ## Examples

  ```elixir
  test "not to change from", %{pid: pid} do
    expect put_value(pid, :foo, 0), not_to_change(get_value(pid, :foo)), from(0)
  end

  test "to change from", %{pid: pid} do
    expect put_value(pid, :foo, 1), to_change(get_value(pid, :foo)), from(0)
  end

  test "to change to", %{pid: pid} do
    expect put_value(pid, :foo, 1), to_change(get_value(pid, :foo)), to(1)
  end

  test "to change by", %{pid: pid} do
    expect put_value(pid, :foo, 1), to_change(get_value(pid, :foo)), by(1)
  end
  ```
  """
  defmacro expect(operation, expression, from_or_by_or_to)

  defmacro expect(operation, {:not_to_change, _, [expression]}, {:from, _, [from]}) do
    expression_string = Macro.to_string(expression)

    quote do
      from = unquote(from)

      case unquote(expression) do
        ^from ->
          unquote(operation)

          case unquote(expression) do
            ^from ->
              :ok

            actual2 ->
              {:error, message2(unquote(expression_string), from, actual2)}
          end

        actual1 ->
          {:error, message1(unquote(expression_string), from, actual1)}
      end
      |> eval_result()
    end
  end

  defmacro expect(operation, {:to_change, _, [expression]}, {:from, _, [from]}) do
    expression_string = Macro.to_string(expression)

    quote do
      from = unquote(from)

      case unquote(expression) do
        ^from ->
          unquote(operation)

          case unquote(expression) do
            ^from ->
              {:error, message3(unquote(expression_string), from)}

            _ ->
              :ok
          end

        actual1 ->
          {:error, message1(unquote(expression_string), from, actual1)}
      end
      |> eval_result()
    end
  end

  defmacro expect(operation, {:to_change, _, [expression]}, {:to, _, [expected]}) do
    expression_string = Macro.to_string(expression)

    quote do
      expected = unquote(expected)

      actual1 = unquote(expression)

      unquote(operation)

      case unquote(expression) do
        ^actual1 ->
          {:error, message7(unquote(expression_string), expected)}

        ^expected ->
          :ok

        actual2 ->
          {:error, message4(unquote(expression_string), expected, actual2)}
      end
      |> eval_result()
    end
  end

  defmacro expect(operation, {:to_change, _, [expression]}, {:by, _, [expected]}) do
    expression_string = Macro.to_string(expression)

    quote do
      expected = unquote(expected)

      actual1 = unquote(expression)

      unquote(operation)

      actual2 = unquote(expression)

      case actual2 - actual1 do
        ^expected ->
          :ok

        actual ->
          {:error, message5(unquote(expression_string), expected, actual)}
      end
      |> eval_result()
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

  defmacro expect(operation, {:to_change, _, [expression]}, {:from, _, [from]}, {:to, _, [to]}) do
    expression_string = Macro.to_string(expression)

    quote do
      from = unquote(from)
      to = unquote(to)

      case unquote(expression) do
        ^from ->
          unquote(operation)

          case unquote(expression) do
            ^to ->
              :ok

            actual2 ->
              {:error, message6(unquote(expression_string), to, actual2)}
          end

        actual1 ->
          {:error, message1(unquote(expression_string), from, actual1)}
      end
      |> eval_result()
    end
  end
end
