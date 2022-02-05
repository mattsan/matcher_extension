defmodule MatcherExtensionTest do
  use ExUnit.Case
  doctest MatcherExtension

  test "greets the world" do
    assert MatcherExtension.hello() == :world
  end
end
