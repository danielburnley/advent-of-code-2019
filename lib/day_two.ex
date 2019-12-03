defmodule DayTwo do
  def execute(input) do
    indexed_input = Enum.with_index(input) |> Enum.map(fn {v, k} -> {k, v} end) |> Map.new()

    part_two = input
    [{:one, run_part_one(indexed_input)}, {:two, part_two}]
  end

  defp run_part_one(program) do
    run_program(%{program | 1 => 12, 2 => 2})
  end
  defp run_program(program, index \\ 0, status \\ :ok)
  defp run_program(program, _, :halt), do: program[0]

  defp run_program(program, index, status) do
    instructions = get_next_instructions(program, index)
    {status, program} = execute_instructions(instructions, program)
    run_program(program, index + 4, status)
  end

  defp execute_instructions({1, first, second, result}, program) do
    program = %{program | result => program[first] + program[second]}
    {:ok, program}
  end

  defp execute_instructions({2, first, second, result}, program) do
    program = %{program | result => program[first] * program[second]}
    {:ok, program}
  end

  defp execute_instructions({99, _, _, _}, program), do: {:halt, program}

  defp get_next_instructions(program, index) do
    {program[index], program[index + 1], program[index + 2], program[index + 3]}
  end
end
