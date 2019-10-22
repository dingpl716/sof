defmodule SofTest do
  use ExUnit.Case
  doctest Sof

  test "greets the world" do
    assert Sof.hello() == :world
  end
end
