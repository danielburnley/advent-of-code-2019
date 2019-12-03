defmodule AdventOfCode2019 do
  @moduledoc """
  Documentation for AdventOfCode2019.
  """

  @doc """
  Hello world.

  ## Examples

      iex> AdventOfCode2019.hello()
      :world

  """
  def run do
    day_one_part_one =
      File.read!("lib/inputs/1.txt")
      |> String.trim()
      |> String.split("\n")
      |> inputs_to_ints
      |> DayOne.execute()

    IO.puts("One #{day_one_part_one[:one]}")
    IO.puts("Two #{day_one_part_one[:two]}")
  end

  defp inputs_to_ints(input), do: Enum.map(input, &String.to_integer(&1))
end
