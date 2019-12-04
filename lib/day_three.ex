defmodule DayThree do
  def execute(input) do
    [first, second] = input
    first = String.split(first, ",") |> DayThree.Parser.parse_instructions |> String.graphemes()
    second = String.split(second, ",") |> DayThree.Parser.parse_instructions |> String.graphemes()
    [{:one, part_one(first, second)}, {:two, "Not yet"}]
  end

  defp part_one(first, second) do
    first_visited = calculate_visited(first)
    second_visited = calculate_visited(second)
    crossover = MapSet.intersection(first_visited, second_visited)
    Enum.map(crossover, fn {x, y} -> abs(x) + abs(y) end) |> Enum.min
  end

  defp calculate_visited(instructions, position \\ {0, 0}, visited \\ [])
  defp calculate_visited([], _, visited), do: MapSet.new(visited)

  defp calculate_visited(["U" | rest], position, visited) do
    new_pos = up(position)
    calculate_visited(rest, new_pos, [new_pos | visited])
  end

  defp calculate_visited(["D" | rest], position, visited) do
    new_pos = down(position)
    calculate_visited(rest, new_pos, [new_pos | visited])
  end

  defp calculate_visited(["L" | rest], position, visited) do
    new_pos = left(position)
    calculate_visited(rest, new_pos, [new_pos | visited])
  end

  defp calculate_visited(["R" | rest], position, visited) do
    new_pos = right(position)
    calculate_visited(rest, new_pos, [new_pos | visited])
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
