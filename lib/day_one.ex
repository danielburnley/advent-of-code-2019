defmodule DayOne do
  def execute(input) do
    part_one = Enum.reduce(input, 0, &(mass_to_fuel(&1) + &2))
    part_two = part_two(0, input, 0)
    [{:one, part_one}, {:two, part_two}]
  end

  defp part_two(0, [], sum), do: sum
  defp part_two(0, [num | rest], sum), do: part_two(num, rest, sum)

  defp part_two(current, input, sum) do
    res = mass_to_fuel(current)
    part_two(res, input, sum + res)
  end

  defp mass_to_fuel(num), do: (trunc(num / 3) - 2) |> clamp
  defp clamp(num) when num < 0, do: 0
  defp clamp(num), do: num
end
