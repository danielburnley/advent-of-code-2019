defmodule OrbitCounterTest do
  defmodule Counter do
    use ExUnit.Case

    test "Single orbit" do
      assert OrbitCounter.count_orbits(["COM)A"]) == 1
    end

    test "Two direct orbits" do
      assert OrbitCounter.count_orbits(["COM)A", "A)B"]) == 3
    end
  end

  defmodule Transfers do
    use ExUnit.Case

    test "No transfers" do
      assert OrbitCounter.count_transfers(["COM)YOU", "COM)SAN"]) == 0
    end

    test "One transfer at COM" do
      assert OrbitCounter.count_transfers(["COM)A", "A)YOU", "COM)SAN"]) == 1
    end

    test "Nested transfers" do
      assert OrbitCounter.count_transfers(["COM)A", "A)B", "A)C", "B)YOU", "C)SAN"]) == 2
    end
  end
end
