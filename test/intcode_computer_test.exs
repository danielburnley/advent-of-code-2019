defmodule IntcodeComputerTest do
  use ExUnit.Case

  test "Addition" do
    input = [1, 0, 0, 3, 99]
    execute_program(input) |> assert_final_program_is([1, 0, 0, 2, 99])
  end

  test "Multiplication" do
    input = [2, 0, 0, 3, 99]
    execute_program(input) |> assert_final_program_is([2, 0, 0, 4, 99])
  end

  test "Day Two: Example 1" do
    input = [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]

    execute_program(input)
    |> assert_final_program_is([3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50])
  end

  test "Day Two: Example 2" do
    input = [1,0,0,0,99]

    execute_program(input)
    |> assert_final_program_is([2,0,0,0,99])
  end

  test "Day Two: Example 3" do
    input = [2,3,0,3,99]

    execute_program(input)
    |> assert_final_program_is([2,3,0,6,99])
  end

  test "Day Two: Example 4" do
    input = [2,4,4,5,99,0]

    execute_program(input)
    |> assert_final_program_is([2,4,4,5,99,9801])
  end

  test "Day Two: Example 5" do
    input = [1,1,1,4,99,5,6,0,99]

    execute_program(input)
    |> assert_final_program_is([30,1,1,4,2,5,6,0,99])
  end

  defp execute_program(input) do
    IntcodeComputer.Parser.parse_array_to_program(input) |> IntcodeComputer.run_program()
  end

  defp assert_final_program_is(actual, expected) do
    assert Map.values(actual) == expected
  end
end
