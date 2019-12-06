defmodule IntcodeComputer do
  def run_program(program, dependencies), do: run_program(program, 0, :ok, dependencies)

  def run_program(
        program,
        index \\ 0,
        status \\ :ok,
        dependencies \\ {fn -> "Not implemented" end}
      )

  def run_program(program, _, :halt, _), do: program

  def run_program(program, index, _status, {input_getter}) do
    instruction = get_next_instruction(program, index)
    parameters = get_instruction_parameters(program, index, instruction)

    {status, program, increment} =
      execute_instruction(instruction, parameters, program, {input_getter})

    run_program(program, index + increment, status)
  end

  defp execute_instruction(1, {first, second, result}, program, _) do
    program = %{program | result => program[first] + program[second]}
    {:ok, program, 4}
  end

  defp execute_instruction(2, {first, second, result}, program, _) do
    program = %{program | result => program[first] * program[second]}
    {:ok, program, 4}
  end

  defp execute_instruction(3, {first}, program, {input_getter}) do
    input = input_getter.() |> String.trim("\n") |> String.to_integer()
    program = %{program | first => input}
    {:ok, program, 2}
  end

  defp execute_instruction(4, {first}, program, _) do
    IO.puts(program[first])
    {:ok, program, 2}
  end

  defp execute_instruction(99, _, program, _), do: {:halt, program, 0}

  defp get_next_instruction(program, index), do: program[index]

  defp get_instruction_parameters(program, index, 3), do: {program[index + 1]}
  defp get_instruction_parameters(program, index, 4), do: {program[index + 1]}

  defp get_instruction_parameters(program, index, _),
    do: {program[index + 1], program[index + 2], program[index + 3]}

  defmodule Parser do
    def parse_array_to_program(input) do
      Enum.with_index(input) |> Enum.map(fn {v, k} -> {k, v} end) |> Map.new()
    end
  end
end
