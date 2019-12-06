defmodule IntcodeComputer do
  def run_program(program, index \\ 0, status \\ :ok)
  def run_program(program, _, :halt), do: program[0]

  def run_program(program, index, _status) do
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
