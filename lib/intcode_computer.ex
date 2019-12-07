defmodule IntcodeComputer do
  def run_program(program, dependencies), do: run_program(program, 0, :ok, dependencies)

  def run_program(
        program,
        index \\ 0,
        status \\ :ok,
        dependencies \\ {fn -> "Not implemented" end}
      )

  def run_program(program, _, :halt, _), do: program

  def run_program(program, index, _status, dependencies) do
    {instruction, modes} = get_next_instruction(program, index)
    parameters = get_instruction_parameters(program, index, instruction)

    {status, program, increment} =
      execute_instruction(instruction, parameters, modes, program, dependencies)

    run_program(program, index + increment, status, dependencies)
  end

  defp execute_instruction(1, {first, second, result}, {m_one, m_two, _m_three}, program, _) do
    program = %{program | result => fetch(program, first, m_one) + fetch(program, second, m_two)}
    {:ok, program, 4}
  end

  defp execute_instruction(2, {first, second, result}, {m_one, m_two, _m_three}, program, _) do
    program = %{program | result => fetch(program, first, m_one) * fetch(program, second, m_two)}
    {:ok, program, 4}
  end

  defp execute_instruction(3, {first}, _, program, {input_getter, _}) do
    input = input_getter.() |> String.trim("\n") |> String.to_integer()
    program = %{program | first => input}
    {:ok, program, 2}
  end

  defp execute_instruction(4, {first}, {m_one, _, _}, program, {_, outputter}) do
    outputter.(fetch(program, first, m_one))
    {:ok, program, 2}
  end

  defp execute_instruction(99, _, _, program, _), do: {:halt, program, 0}

  defp get_next_instruction(program, index) do
    {modes, operation} =
      program[index]
      |> Integer.to_string()
      |> String.pad_leading(5, "0")
      |> String.graphemes()
      |> Enum.split(3)

    [m_three, m_two, m_one] = Enum.map(modes, &String.to_integer(&1))
    operation = Enum.join(operation) |> String.to_integer()

    {operation, {m_one, m_two, m_three}}
  end

  defp get_instruction_parameters(program, index, 3), do: {program[index + 1]}
  defp get_instruction_parameters(program, index, 4), do: {program[index + 1]}

  defp get_instruction_parameters(program, index, _),
    do: {program[index + 1], program[index + 2], program[index + 3]}

  defp fetch(program, value, mode)
  defp fetch(program, value, 0), do: program[value]
  defp fetch(_program, value, 1), do: value

  defmodule Parser do
    def parse_array_to_program(input) do
      Enum.with_index(input) |> Enum.map(fn {v, k} -> {k, v} end) |> Map.new()
    end
  end
end
