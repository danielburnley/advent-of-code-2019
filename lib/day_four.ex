defmodule DayFour do
  def execute(lower, upper) do
    potentials = for x <- lower..upper, do: Integer.to_string(x)
    [{:one, part_one(potentials)}, {:two, part_two(potentials)}]
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

  defp part_two(nums, count \\ 0)
  defp part_two([], count), do: count

  defp part_two([num | rest], count) do
    cond do
      contains_duplicates_not_part_of_larger_group?(num) and is_ascending_only?(num) ->
        part_two(rest, count + 1)

      true ->
        part_two(rest, count)
    end
  end

  def contains_duplicates_not_part_of_larger_group?(num) do
    adjacent_duplicates_not_part_of_larger_group(num) |> Enum.any?()
  end

  def adjacent_duplicates_not_part_of_larger_group(num) do
    get_adjacent_duplicates(num) -- get_adjacent_larger_groups(num)
  end

  def get_adjacent_duplicates(num) do
    Regex.scan(~r/(\d)\1/, num) |> Enum.uniq() |> Enum.map(fn [_, y] -> y end)
  end

  def get_adjacent_larger_groups(num) do
    Regex.scan(~r/(\d)\1{2,}/, num) |> Enum.uniq() |> Enum.map(fn [_, y] -> y end)
  end

  defp has_adjacent_duplicates?(num) do
    String.match?(num, ~r/(\d)\1/)
  end

  defp is_ascending_only?(num) do
    split_num = String.graphemes(num)

    Enum.sort(split_num) == split_num
  end
end
