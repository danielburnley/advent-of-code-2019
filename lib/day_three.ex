defmodule DayThree do
  def execute(input) do
    [first, second] = input
    first = String.split(first, ",") |> DayThree.Parser.parse_instructions() |> String.graphemes()

    second =
      String.split(second, ",") |> DayThree.Parser.parse_instructions() |> String.graphemes()

    [{:one, part_one(first, second)}, {:two, part_two(first, second)}]
  end

  defp part_one(first, second) do
    first_visited = calculate_visited(first) |> visited_coords
    second_visited = calculate_visited(second) |> visited_coords
    crossover = MapSet.intersection(first_visited, second_visited)
    Enum.map(crossover, fn {x, y} -> abs(x) + abs(y) end) |> Enum.min()
  end

  defp part_two(first, second) do
    first_visited = calculate_visited(first)
    second_visited = calculate_visited(second)

    crossover = MapSet.intersection(visited_coords(first_visited), visited_coords(second_visited))
    Enum.map(crossover, fn pos -> first_visited[pos] + second_visited[pos] end) |> Enum.min()
  end

  defp visited_coords(visited_with_steps) do
    visited_with_steps |> Map.keys() |> MapSet.new()
  end

  defp calculate_visited(instructions, position \\ {0, 0}, steps \\ 1, visited \\ %{})
  defp calculate_visited([], _, _, visited), do: visited

  defp calculate_visited(["U" | rest], position, steps, visited) do
    new_pos = up(position)
    calculate_visited(rest, new_pos, steps + 1, Map.put_new(visited, new_pos, steps))
  end

  defp calculate_visited(["D" | rest], position, steps, visited) do
    new_pos = down(position)
    calculate_visited(rest, new_pos, steps + 1, Map.put_new(visited, new_pos, steps))
  end

  defp calculate_visited(["L" | rest], position, steps, visited) do
    new_pos = left(position)
    calculate_visited(rest, new_pos, steps + 1, Map.put_new(visited, new_pos, steps))
  end

  defp calculate_visited(["R" | rest], position, steps, visited) do
    new_pos = right(position)
    calculate_visited(rest, new_pos, steps + 1, Map.put_new(visited, new_pos, steps))
  end

  defp up({x, y}), do: {x, y + 1}
  defp down({x, y}), do: {x, y - 1}
  defp left({x, y}), do: {x - 1, y}
  defp right({x, y}), do: {x + 1, y}

  defmodule Parser do
    def parse_instructions(instructions, parsed \\ "")
    def parse_instructions([], parsed), do: parsed

    def parse_instructions(["U" <> times | rest], parsed) do
      parse_instructions(rest, parsed <> String.duplicate("U", String.to_integer(times)))
    end

    def parse_instructions(["D" <> times | rest], parsed) do
      parse_instructions(rest, parsed <> String.duplicate("D", String.to_integer(times)))
    end

    def parse_instructions(["L" <> times | rest], parsed) do
      parse_instructions(rest, parsed <> String.duplicate("L", String.to_integer(times)))
    end

    def parse_instructions(["R" <> times | rest], parsed) do
      parse_instructions(rest, parsed <> String.duplicate("R", String.to_integer(times)))
    end
  end
end
