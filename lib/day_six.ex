defmodule DaySix do
  def execute(input) do
    part_one = OrbitCounter.execute(input)
    [{:one, part_one}, {:two, "Not yet"}]
  end
end
