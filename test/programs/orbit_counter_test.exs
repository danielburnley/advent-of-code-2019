defmodule OrbitCounterTest do
  use ExUnit.Case

  test "Single orbit" do
    assert OrbitCounter.execute(["COM)A"]) == 1
  end

  test "Two direct orbits" do
    assert OrbitCounter.execute(["COM)A", "A)B"]) == 3
  end
end
