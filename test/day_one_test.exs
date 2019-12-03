defmodule DayOneTest do
  use ExUnit.Case

  test "Day one" do
    output =
      File.read!("lib/inputs/1.txt")
      |> String.trim()
      |> String.split("\n")
      |> inputs_to_ints
      |> DayOne.execute()

    assert output[:one] == 3_328_306
  end

  defp inputs_to_ints(input), do: Enum.map(input, &String.to_integer(&1))
end
