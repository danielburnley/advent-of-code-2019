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
    day_one =
      file_to_inputs(1)
      |> inputs_to_ints
      |> DayOne.execute()

    IO.puts("1.1 #{day_one[:one]}")
    IO.puts("1.2 #{day_one[:two]}")
  end

  defp inputs_to_ints(input), do: Enum.map(input, &String.to_integer(&1))

  defp file_to_inputs(day) do
    File.read!("lib/inputs/#{day}.txt")
    |> String.trim()
    |> String.split("\n")
  end
end
