defmodule AdventOfCode2019 do
  def run do
    day_one()
    day_two()
    day_three()
    day_four()
  end

  defp day_one do
    result =
      read_input(1)
      |> split_by_new_line
      |> to_ints
      |> DayOne.execute()

    IO.puts("1.1 #{result[:one]}")
    IO.puts("1.2 #{result[:two]}")
  end

  defp day_two do
    result =
      read_input(2)
      |> split_by_comma
      |> to_ints
      |> DayTwo.execute()

    IO.puts("2.1 #{result[:one]}")
    IO.puts("2.2 #{result[:two]}")
  end

  defp day_three do
    result = read_input(3) |> split_by_new_line |> DayThree.execute()

    IO.puts("3.1 #{result[:one]}")
    IO.puts("3.2 #{result[:two]}")
  end

  defp day_four do
    result = DayFour.execute(273_025, 767_253)

    IO.puts("4.1 #{result[:one]}")
    IO.puts("4.2 #{result[:two]}")
  end

  defp to_ints(input), do: Enum.map(input, &String.to_integer(&1))
  defp split_by_new_line(input), do: String.split(input, "\n")
  defp split_by_comma(input), do: String.split(input, ",")
  defp read_input(day), do: File.read!("lib/inputs/#{day}.txt") |> String.trim()
end
