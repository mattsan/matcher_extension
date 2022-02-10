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
  @spec eval_result({:error, String.t()} | :ok) :: any()
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

          :ok ->
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
      previous_value = unquote(expression)

      unquote(operation)

      case unquote(expression) do
        ^previous_value ->
          :ok

        present_value ->
          {:error, has_changed_error(unquote(expression_string), from: previous_value, to: present_value)}
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
  defmacro expect(operation, expression, from_or_to_or_by)

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

            present_value ->
              {:error, has_changed_error(unquote(expression_string), from: from, to: present_value)}
          end

        previous_value ->
          {:error, initial_value_error(unquote(expression_string), expected: from, actual: previous_value)}
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
              {:error, has_not_changed_error(unquote(expression_string), from: from)}

            _ ->
              :ok
          end

        previous_value ->
          {:error, initial_value_error(unquote(expression_string), expected: from, actual: previous_value)}
      end
      |> eval_result()
    end
  end

  defmacro expect(operation, {:to_change, _, [expression]}, {:to, _, [to]}) do
    expression_string = Macro.to_string(expression)

    quote do
      to = unquote(to)

      previous_value = unquote(expression)

      unquote(operation)

      case unquote(expression) do
        ^previous_value ->
          {:error, has_not_changed_error(unquote(expression_string), to: to)}

        ^to ->
          :ok

        present_value ->
          {:error, unexpected_change_error(unquote(expression_string), to: to, actual: present_value)}
      end
      |> eval_result()
    end
  end

  defmacro expect(operation, {:to_change, _, [expression]}, {:by, _, [by]}) do
    expression_string = Macro.to_string(expression)

    quote do
      by = unquote(by)

      previous_value = unquote(expression)

      unquote(operation)

      present_value = unquote(expression)

      case present_value - previous_value do
        ^by ->
          :ok

        actual ->
          {:error, unexpected_change_error(unquote(expression_string), by: by, actual: actual)}
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

            ^from ->
              {:error, has_not_changed_error(unquote(expression_string), from: from, to: to)}

            present_value ->
              {:error, unexpected_change_error(unquote(expression_string), to: to, actual: present_value)}
          end

        previous_value ->
          {:error, initial_value_error(unquote(expression_string), expected: from, actual: previous_value)}
      end
      |> eval_result()
    end
  end
end
