defmodule Matcher.Extension.ExpectationTest do
  use ExUnit.Case
  doctest Matcher.Extension.Expectation

  import Matcher.Extension.Expectation

  def put_value(pid, key, value) do
    Agent.update(pid, &Map.put(&1, key, value))
  end

  def get_value(pid, key) do
    Agent.get(pid, &Map.get(&1, key))
  end

  setup do
    {:ok, pid} = start_supervised({Agent, fn -> %{foo: 0} end})

    [pid: pid]
  end

  describe "expect OPERATION not to change EXPRESSION" do
    test "success", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: 0,
        actual: 0
      }

      assert expected == expect(put_value(pid, :foo, 0), not_to_change(get_value(pid, :foo)))
    end

    test "failure", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: 0,
        actual: 1
      }

      assert expected == expect(put_value(pid, :foo, 1), not_to_change(get_value(pid, :foo)))
    end
  end

  describe "expect OPERATION not to change EXPRESSION from VALUE" do
    test "success", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: %{from: 0},
        actual: %{from: 0}
      }

      assert expected == expect(put_value(pid, :foo, 0), not_to_change(get_value(pid, :foo)), from(0))
    end

    test "failure", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: %{from: 0},
        actual: %{from: 1}
      }

      assert expected == expect(put_value(pid, :foo, 1), not_to_change(get_value(pid, :foo)), from(0))
    end
  end

  describe "expect OPERATION to change EXPRESSION to VALUE" do
    test "success", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: %{to: 1},
        actual: %{to: 1}
      }

      assert expected == expect(put_value(pid, :foo, 1), to_change(get_value(pid, :foo)), to(1))
    end

    test "failure", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: %{to: 1},
        actual: %{to: 2}
      }

      assert expected == expect(put_value(pid, :foo, 2), to_change(get_value(pid, :foo)), to(1))
    end
  end

  describe "expect OPERATION to change EXPRESSION from VALUE to ANOTHER_VALUE" do
    test "success", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: %{from: 0, to: 1},
        actual: %{from: 0, to: 1}
      }

      assert expected == expect(put_value(pid, :foo, 1), to_change(get_value(pid, :foo)), from(0), to(1))
    end

    test "failure (1)", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: %{from: 0, to: 1},
        actual: %{from: 0, to: 2}
      }

      assert expected == expect(put_value(pid, :foo, 2), to_change(get_value(pid, :foo)), from(0), to(1))
    end

    test "failure (2)", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: %{from: 1, to: 1},
        actual: %{from: 0, to: 1}
      }

      assert expected == expect(put_value(pid, :foo, 1), to_change(get_value(pid, :foo)), from(1), to(1))
    end
  end

  describe "expect OPERATION to change EXPRESSION by VALUE" do
    test "success", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: %{by: 1},
        actual: %{by: 1}
      }

      assert expected == expect(put_value(pid, :foo, 1), to_change(get_value(pid, :foo)), by(1))
    end

    test "failure", %{pid: pid} do
      expected = %{
        expression: "get_value(pid, :foo)",
        expected: %{by: 1},
        actual: %{by: 2}
      }

      assert expected == expect(put_value(pid, :foo, 2), to_change(get_value(pid, :foo)), by(1))
    end
  end
end
