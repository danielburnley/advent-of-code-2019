defmodule AdventOfCode2019 do
  def run do
    day_one =
      read_input(1)
      |> split_by_new_line
      |> to_ints
      |> DayOne.execute()

    IO.puts("1.1 #{day_one[:one]}")
    IO.puts("1.2 #{day_one[:two]}")

    day_two =
      read_input(2)
      |> split_by_comma
      |> to_ints
      |> DayTwo.execute()

    IO.puts("2.1 #{day_two[:one]}")
    IO.puts("2.2 #{day_two[:two]}")
  end

  defp to_ints(input), do: Enum.map(input, &String.to_integer(&1))
  defp split_by_new_line(input), do: String.split(input, "\n")
  defp split_by_comma(input), do: String.split(input, ",")
  defp read_input(day), do: File.read!("lib/inputs/#{day}.txt") |> String.trim()
end
