defmodule MonitoringStation do
  def find_maximum_viewable_asteroids(input) do
    input = input_to_coords(input)
    possible_positions = get_coords_with_asteroids(input)

    viewable_totals =
      Enum.map(possible_positions, fn position ->
        {position, Enum.count(get_viewable_asteroids(position, input, possible_positions -- [position]))}
      end)

    Enum.max_by(viewable_totals, fn {_, count} -> count end)
  end

  def get_vapourised_asteroids(input) do
    {station_position, _} = find_maximum_viewable_asteroids(input)
    input = input_to_coords(input)

    possible_positions = get_coords_with_asteroids(input)
    viewable_asteroids = get_viewable_asteroids(station_position, input, possible_positions -- [station_position])

    {x,y} = station_position
    halves_and_slopes = Enum.map(viewable_asteroids, fn {x2,y2} ->
        {
          get_half({x,y}, {x2, y2}),
          get_slope({x,y}, {x2,y2}),
          {x2,y2}
        }
      end
    )

    grouped_inputs = Enum.group_by(halves_and_slopes, fn {half, _, _} -> half end)
    right_half = Enum.sort_by(grouped_inputs[1], fn {_, slope, _} -> slope * - 1 end)
    left_half = Enum.sort_by(grouped_inputs[2], fn {_, slope, _} -> slope * -1 end)
    
    (right_half ++ left_half) |> Enum.map(fn {_,_, pos} -> pos end)
  end

  def get_half({x,y}, {x, y2}) when y2 < y, do: 1
  def get_half({x,y}, {x, y2}) when y2 > y, do: 2
  def get_half({x,_}, {x2, _}) when x2 > x, do: 1
  def get_half({x,_}, {x2, _}) when x2 < x, do: 2

  def get_slope({x,y}, {x,y2}) when y2 > y, do: 999999
  def get_slope({x,y}, {x,y2}) when y2 < y, do: 999999
  def get_slope({x,y}, {x2,y2}) do
    Float.round((y2 - y) / (x2 - x) * - 1, 5)
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

  defp get_viewable_asteroids(position, input, possible_positions, res \\ [])
  defp get_viewable_asteroids(_position, _input, [], res), do: res

  defp get_viewable_asteroids(position, input, [possible_position | rest], res) do
    intersections = Coordinates.calculate_intersecting_points(position, possible_position)
    chars_at_intersections = Enum.map(intersections, fn {x, y} -> input[y][x] end)
    asteroid_count = Enum.count(chars_at_intersections, &(&1 == "#"))

    cond do
      asteroid_count > 0 ->
        get_viewable_asteroids(position, input, rest, res)

      true ->
        get_viewable_asteroids(position, input, rest, [possible_position|res])
    end
  end
end
