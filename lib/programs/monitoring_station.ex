defmodule MonitoringStation do
  def find_maximum_viewable_asteroids(input) do
    input = input_to_coords(input)
    possible_positions = get_coords_with_asteroids(input)

    viewable_totals =
      Enum.map(possible_positions, fn position ->
        {position, get_viewable_asteroids(position, input, possible_positions -- [position])}
      end)

    {_, total_viewable} = Enum.max_by(viewable_totals, fn {_, count} -> count end)

    total_viewable
  end

  defp input_to_coords(input, res \\ %{}, y \\ 0)
  defp input_to_coords([], res, _), do: res

  defp input_to_coords([row | rest], res, y) do
    row_with_index =
      Stream.with_index(row)
      |> Enum.to_list()
      |> Enum.reduce(%{}, fn {ch, x}, map -> Map.put(map, x, ch) end)

    res = Map.put(res, y, row_with_index)
    input_to_coords(rest, res, y + 1)
  end

  defp get_coords_with_asteroids(input) do
    Enum.map(input, fn {y, x_vals} ->
      Enum.filter(x_vals, fn {_, v} -> v == "#" end)
      |> Enum.map(fn {x, _} -> {x, y} end)
    end)
    |> List.flatten()
  end

  defp get_viewable_asteroids(position, input, possible_positions, count \\ 0)
  defp get_viewable_asteroids(_position, _input, [], count), do: count

  defp get_viewable_asteroids(position, input, [possible_position | rest], count) do
    intersections = Coordinates.calculate_intersecting_points(position, possible_position)
    chars_at_intersections = Enum.map(intersections, fn {x, y} -> input[y][x] end)
    asteroid_count = Enum.count(chars_at_intersections, &(&1 == "#"))

    cond do
      asteroid_count > 0 ->
        get_viewable_asteroids(position, input, rest, count)

      true ->
        get_viewable_asteroids(position, input, rest, count + 1)
    end
  end
end
