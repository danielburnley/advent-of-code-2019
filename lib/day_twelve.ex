defmodule DayTwelve do
  def execute do
    inputs = [
      {13, -13, -2},
      {16, 2, -15},
      {7, -18, -12},
      {-3, -8, -8}
    ]

    {x, y, z} = part_two(inputs)

    [{:one, part_one(inputs)}, {:two, "X: #{x}, Y: #{y}, Z: #{z}"}]
  end

  defp part_one(inputs) do
    MoonMotionSimulator.get_positions_at_step(inputs, 1000)
    |> Enum.map(fn {{mx, my, mz}, {vx, vy, vz}} ->
      potential_energy = abs(mx) + abs(my) + abs(mz)
      kinetic_energy = abs(vx) + abs(vy) + abs(vz)
      potential_energy * kinetic_energy
    end)
    |> Enum.sum()
  end

  defp part_two(inputs) do
    MoonMotionSimulator.get_steps_until_repeat(inputs)
  end
end
