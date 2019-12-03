defmodule DayTwo do
  def execute(input) do
    indexed_input = Enum.with_index(input) |> Enum.map(fn {v, k} -> {k, v} end) |> Map.new()

    [{:one, run_part_one(indexed_input)}, {:two, run_part_two(indexed_input)}]
  end

  defp run_part_one(program) do
    run_program(%{program | 1 => 12, 2 => 2})
  end

  defp run_part_two(program) do
    elements = 1..99
    inputs = for x <- elements, y <- elements, do: [x, y]
    [noun, verb] = run_part_two(program, inputs, {})
    100 * noun + verb
  end

  defp run_part_two(program, _, {inputs, 19690720}), do: inputs
  defp run_part_two(program, [inputs|rest], _) do
    [a, b] = inputs
    output = run_program(%{program | 1 => a, 2 => b})
    run_part_two(program, rest, {inputs, output})
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
