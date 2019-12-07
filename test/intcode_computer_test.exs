defmodule IntcodeComputerTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "Addition" do
    input = [1, 0, 0, 3, 99]
    execute_program(input) |> assert_final_program_is([1, 0, 0, 2, 99])
  end

  test "Immediate addition" do
    input = [101, 2, 4, 3, 99]
    execute_program(input) |> assert_final_program_is([101, 2, 4, 101, 99])
  end

  test "Multiplication" do
    input = [2, 0, 0, 3, 99]
    execute_program(input) |> assert_final_program_is([2, 0, 0, 4, 99])
  end

  test "Input" do
    input_stub = fn -> "10\n" end
    execute_program([3, 0, 99], input_stub) |> assert_final_program_is([10, 0, 99])
  end

  test "Output" do
    program_to_run = fn ->
      execute_program([4, 0, 99])
    end

    program_to_run.() |> assert_final_program_is([4, 0, 99])
    assert_program_outputs(program_to_run, "4\n")
  end

  test "Day Two: Example 1" do
    input = [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]

    execute_program(input)
    |> assert_final_program_is([3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50])
  end

  test "Day Two: Example 2" do
    input = [1, 0, 0, 0, 99]

    execute_program(input)
    |> assert_final_program_is([2, 0, 0, 0, 99])
  end

  test "Day Two: Example 3" do
    input = [2, 3, 0, 3, 99]

    execute_program(input)
    |> assert_final_program_is([2, 3, 0, 6, 99])
  end

  test "Day Two: Example 4" do
    input = [2, 4, 4, 5, 99, 0]

    execute_program(input)
    |> assert_final_program_is([2, 4, 4, 5, 99, 9801])
  end

  test "Day Two: Example 5" do
    input = [1, 1, 1, 4, 99, 5, 6, 0, 99]

    execute_program(input)
    |> assert_final_program_is([30, 1, 1, 4, 2, 5, 6, 0, 99])
  end

  test "Day Five: Example 1" do
    input = [3, 0, 4, 0, 99]
    input_getter = fn -> "10\n" end
    program_to_run = fn -> execute_program(input, input_getter) end

    program_to_run.() |> assert_final_program_is([10, 0, 4, 0, 99])
    assert_program_outputs(program_to_run, "10\n")
  end

  defp execute_program(input) do
    IntcodeComputer.Parser.parse_array_to_program(input)
    |> IntcodeComputer.run_program({fn -> "" end})
  end

  defp execute_program(input, input_getter_stub) do
    IntcodeComputer.Parser.parse_array_to_program(input)
    |> IntcodeComputer.run_program({input_getter_stub})
  end

  defp assert_final_program_is(actual, expected) do
    assert Map.values(actual) == expected
  end

  defp assert_program_outputs(program_to_run, expected_output) do
    assert capture_io(program_to_run) == expected_output
  end
end
