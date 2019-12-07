defmodule DaySix do
  def execute(input) do
    part_one = OrbitCounter.count_orbits(input)
    part_two = OrbitCounter.count_transfers(input)
    [{:one, part_one}, {:two, part_two}]
  end
end
