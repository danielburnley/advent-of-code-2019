defmodule MoonMotionSimulator do
  def get_positions_at_step(moons, step) do
    Enum.map(moons, fn moon -> {moon, {0, 0, 0}} end)
    |> simulate_motion(step)
  end

  def get_steps_until_repeat(moons) do
    xs = Enum.map(moons, fn {x, _, _} -> x end) |> Enum.map(fn x -> {x, 0} end)
    ys = Enum.map(moons, fn {_, y, _} -> y end) |> Enum.map(fn y -> {y, 0} end)
    zs = Enum.map(moons, fn {_, _, z} -> z end) |> Enum.map(fn z -> {z, 0} end)

    x_repeat_step = get_steps_for_axis(xs, xs)
    y_repeat_step = get_steps_for_axis(ys, ys)
    z_repeat_step = get_steps_for_axis(zs, zs)

    {x_repeat_step, y_repeat_step, z_repeat_step}
  end

  defp get_steps_for_axis(values, original, steps \\ 0)
  defp get_steps_for_axis(values, values, steps) when steps > 0, do: steps

  defp get_steps_for_axis(values, original, steps) do
    new_values = Enum.map(values, fn value ->
      {pos, velocity} = value
      new_velocity = calculate_velocity_for_axis(pos, velocity, values -- [value])
      new_pos = pos + new_velocity

      {new_pos, new_velocity}
    end)

    get_steps_for_axis(new_values, original, steps + 1)
  end

  defp calculate_velocity_for_axis(_, velocity, []), do: velocity

  defp calculate_velocity_for_axis(pos, velocity, [{other, _} | rest]) do
    new_velocity = velocity + calculate_change(pos, other)
    calculate_velocity_for_axis(pos, new_velocity, rest)
  end

  defp simulate_motion(moons, steps)
  defp simulate_motion(moons, 0), do: moons

  defp simulate_motion(moons, steps) do
    new_positions =
      Enum.map(moons, fn moon ->
        {pos, velocity} = moon
        new_velocity = calculate_velocity(pos, velocity, moons -- [moon])
        new_pos = apply_velocity(pos, new_velocity)

        {new_pos, new_velocity}
      end)

    simulate_motion(new_positions, steps - 1)
  end

  defp apply_velocity({x, y, z}, {vx, vy, vz}), do: {x + vx, y + vy, z + vz}

  defp calculate_velocity(_moon, velocity, []), do: velocity

  defp calculate_velocity(moon, velocity, [other_moon | rest]) do
    {x, y, z} = moon
    {{x2, y2, z2}, _} = other_moon
    {vx, vy, vz} = velocity

    new_velocity = {
      vx + calculate_change(x, x2),
      vy + calculate_change(y, y2),
      vz + calculate_change(z, z2)
    }

    calculate_velocity(moon, new_velocity, rest)
  end

  defp calculate_change(a, a), do: 0
  defp calculate_change(a, b) when a < b, do: 1
  defp calculate_change(a, b) when a > b, do: -1
end
