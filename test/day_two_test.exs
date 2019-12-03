defmodule DayTwoTest do
  use ExUnit.Case

  test "Day two final" do
    output = get_file_input |> DayTwo.execute()
    assert output[:one] == 3_328_306
  end

  test "Day two add" do
    output = DayTwo.execute([1, 2, 2, 0, 99])
    assert output[:one] == 4
  end

  test "Day two multiply" do
    output = DayTwo.execute([2, 5, 5, 0, 99, 3])
    assert output[:one] == 9
  end
   
  test "idek" do
    output = DayTwo.execute([1,1,1,4,99,5,6,0,99])
    assert output[:one] == 30
  end
  
  test "again" do
    output = DayTwo.execute([1,0,0,4,99,4,0,8,99,0,3,0,99])
    assert output[:one] == 4
  end

  test "acceptance" do
    input = [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]
    output = DayTwo.execute(input)
    assert output[:one] == 3500
  end

  defp inputs_to_ints(input), do: Enum.map(input, &String.to_integer(&1))

  defp get_file_input do
    File.read!("lib/inputs/2.txt")
    |> String.trim()
    |> String.split(",")
    |> inputs_to_ints
  end
end
