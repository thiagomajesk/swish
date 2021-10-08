defmodule SwishTest do
  use ExUnit.Case
  doctest Swish

  test "greets the world" do
    assert Swish.hello() == :world
  end
end
