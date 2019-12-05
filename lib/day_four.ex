defmodule DayFour do
  def execute(lower, upper) do
    potentials = for x <- lower..upper, do: Integer.to_string(x)
    [{:one, part_one(potentials)}, {:two, part_two()}]
  end

  defp part_one(nums, count \\ 0)
  defp part_one([], count), do: count

  defp part_one([num | rest], count) do
    cond do
      has_adjacent_duplicates?(num) and is_ascending_only?(num) ->
        part_one(rest, count + 1)

      true ->
        part_one(rest, count)
    end
  end

  defp part_two do
    "Nope"
  end

  defp has_adjacent_duplicates?(num) do
    String.match?(num, ~r/(\d)\1/)
  end

  defp is_ascending_only?(num) do
    split_num = String.graphemes(num)

    Enum.sort(split_num) == split_num
  end
end
