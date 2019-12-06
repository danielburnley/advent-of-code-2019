defmodule IntcodeComputer do
  def run_program(program, index \\ 0, status \\ :ok)
  def run_program(program, _, :halt), do: program[0]

  def run_program(program, index, _status) do
    instruction = get_next_instruction(program, index)
    parameters = get_instruction_parameters(program, index, instruction)
    {status, program} = execute_instruction(instruction, parameters, program)
    run_program(program, index + 4, status)
  end

  defp execute_instruction(1, {first, second, result}, program) do
    program = %{program | result => program[first] + program[second]}
    {:ok, program}
  end

  defp execute_instruction(2, {first, second, result}, program) do
    program = %{program | result => program[first] * program[second]}
    {:ok, program}
  end
  
  defp execute_instruction(99, _, program), do: {:halt, program}

  defp get_next_instruction(program, index), do: program[index]

  defp get_instruction_parameters(program, index, 3), do: program[index+1]
  defp get_instruction_parameters(program, index, 4), do: program[index+1]
  defp get_instruction_parameters(program, index, _), do: { program[index+1], program[index+2], program[index+3] }

  defp get_next_instructions(program, index) do
    {program[index], program[index + 1], program[index + 2], program[index + 3]}
  end
end
