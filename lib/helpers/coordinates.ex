defmodule Coordinates do
  def calculate_intersecting_points({x, y}, {x2, y2}) do
    dx = x2 - x
    dy = y2 - y

    number_of_points = Integer.gcd(dx, dy) - 1
    gcd_of_differences = Integer.gcd(dx, dy)
    gap_x = trunc(dx / gcd_of_differences)
    gap_y = trunc(dy / gcd_of_differences)

    calculate({x, y}, {gap_x, gap_y}, number_of_points)
  end

  defp calculate(pos, increments, number, res \\ [])
  defp calculate(_, _, 0, res), do: res

  defp calculate({x, y}, {inc_x, inc_y}, number, res) do
    next_pos = {
      x + inc_x,
      y + inc_y
    }

    calculate(next_pos, {inc_x, inc_y}, number - 1, [next_pos | res])
  end
end
