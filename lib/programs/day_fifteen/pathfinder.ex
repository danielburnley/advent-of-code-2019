defmodule DayFifteen.Pathfinder do
  def get_inputs_for_path(position, path, inputs \\ [])
  def get_inputs_for_path(_position, [], inputs), do: Enum.reverse(inputs)

  def get_inputs_for_path(position, [next | rest], inputs) do
    get_inputs_for_path(next, rest, [get_input_from_a_to_b(position, next) | inputs])
  end

  defp get_input_from_a_to_b({x, y}, {x, y2}) when y2 > y, do: 1
  defp get_input_from_a_to_b({x, y}, {x, y2}) when y2 < y, do: 2
  defp get_input_from_a_to_b({x, y}, {x2, y}) when x2 < x, do: 3
  defp get_input_from_a_to_b({x, y}, {x2, y}) when x2 > x, do: 4

  def get_path(position, destination, ship, paths \\ [], visited \\ [])

  def get_path(position, destination, ship, [], _visited) do
    possible_moves =
      get_possible_known_moves(ship, position, destination)
      |> Enum.map(fn pos -> {pos, %{pos => position}} end)

    case Enum.any?(possible_moves, fn {current_pos, _} -> current_pos == destination end) do
      true ->
        {_, path} = Enum.find(possible_moves, fn {pos, _} -> pos == destination end)
        get_path_from_map(destination, position, path)

      false ->
        visited = Enum.map(possible_moves, fn {pos, _} -> pos end)
        get_path(position, destination, ship, possible_moves, visited)
    end
  end

  def get_path(position, destination, ship, path, visited) do
    possible_moves =
      Enum.flat_map(path, fn {current_pos, map} ->
        get_possible_known_moves(ship, current_pos, destination)
        |> Enum.reject(fn pos -> pos in visited end)
        |> Enum.map(fn pos -> {pos, Map.put(map, pos, current_pos)} end)
      end)

    case Enum.any?(possible_moves, fn {current_pos, _} -> current_pos == destination end) do
      true ->
        {_, path} = Enum.find(possible_moves, fn {pos, _} -> pos == destination end)
        get_path_from_map(destination, position, path)

      false ->
        visited = Enum.map(path, fn {pos, _} -> pos end) ++ visited
        get_path(position, destination, ship, possible_moves, visited)
    end
  end

  def get_path_from_map(current_position, start_point, map, path \\ [])
  def get_path_from_map(start_point, start_point, _map, path), do: path -- [start_point]

  def get_path_from_map(current_position, start_point, map, []) do
    get_path_from_map(current_position, start_point, map, [current_position])
  end

  def get_path_from_map(current_position, start_point, map, path) do
    path = [map[current_position] | path]
    get_path_from_map(map[current_position], start_point, map, path)
  end

  def get_possible_known_moves(ship, position, destination) do
    get_adjacent_locations(position)
    |> MapSet.to_list()
    |> Enum.filter(fn pos -> Map.get(ship, pos, -1) > 0 or pos == destination end)
  end

  def get_possible_moves(ship, position) do
    unknown_locations = get_unknown_locations(ship)

    get_adjacent_locations(position)
    |> MapSet.to_list()
    |> Enum.filter(fn pos -> Map.get(ship, pos, -1) > 0 or pos in unknown_locations end)
  end

  def get_unknown_locations(ship) do
    existing = MapSet.new(Map.keys(ship))
    open_spaces = Enum.filter(ship, fn {_, v} -> v != 0 end) |> Enum.map(fn {k, _} -> k end)

    Enum.reduce(open_spaces, MapSet.new(), fn pos, acc ->
      MapSet.union(acc, get_adjacent_locations(pos))
      |> MapSet.difference(existing)
    end)
  end

  def get_adjacent_locations({x, y}) do
    MapSet.new([
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ])
  end
end
