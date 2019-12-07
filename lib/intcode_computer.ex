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

    {status, program, new_index} =
      execute_instruction(instruction, index, parameters, modes, program, dependencies)

    run_program(program, new_index, status, dependencies)
  end

  defp execute_instruction(
         1,
         current_index,
         {first, second, result},
         {m_one, m_two, _m_three},
         program,
         _
       ) do
    program = %{program | result => fetch(program, first, m_one) + fetch(program, second, m_two)}
    {:ok, program, current_index + 4}
  end

  defp execute_instruction(
         2,
         current_index,
         {first, second, result},
         {m_one, m_two, _m_three},
         program,
         _
       ) do
    program = %{program | result => fetch(program, first, m_one) * fetch(program, second, m_two)}
    {:ok, program, current_index + 4}
  end

  defp execute_instruction(3, current_index, {first}, _, program, {input_getter, _}) do
    input = input_getter.() |> String.trim("\n") |> String.to_integer()
    program = %{program | first => input}
    {:ok, program, current_index + 2}
  end

  defp execute_instruction(4, current_index, {first}, {m_one, _, _}, program, {_, outputter}) do
    outputter.(fetch(program, first, m_one))
    {:ok, program, current_index + 2}
  end

  defp execute_instruction(5, current_index, {first, second}, {m_one, m_two, _}, program, _) do
    first_input = fetch(program, first, m_one)
    second_input = fetch(program, second, m_two)
    new_index = execute_jump_if_true(current_index, first_input, second_input)
    {:ok, program, new_index}
  end

  defp execute_instruction(6, current_index, {first, second}, {m_one, m_two, _}, program, _) do
    first_input = fetch(program, first, m_one)
    second_input = fetch(program, second, m_two)
    new_index = execute_jump_if_false(current_index, first_input, second_input)
    {:ok, program, new_index}
  end

  defp execute_instruction(
         7,
         current_index,
         {first, second, result},
         {m_one, m_two, _},
         program,
         _
       ) do
    first_input = fetch(program, first, m_one)
    second_input = fetch(program, second, m_two)
    program = %{program | result => less_than(first_input, second_input)}
    {:ok, program, current_index + 4}
  end

  defp execute_instruction(
         8,
         current_index,
         {first, second, result},
         {m_one, m_two, _},
         program,
         _
       ) do
    first_input = fetch(program, first, m_one)
    second_input = fetch(program, second, m_two)
    program = %{program | result => equals(first_input, second_input)}
    {:ok, program, current_index + 4}
  end

  defp execute_instruction(99, _, _, _, program, _), do: {:halt, program, 0}

  defp execute_jump_if_true(index, 0, _second_input), do: index + 3
  defp execute_jump_if_true(_index, _, second_input), do: second_input

  defp execute_jump_if_false(_index, 0, second_input), do: second_input
  defp execute_jump_if_false(index, _, _second_input), do: index + 3

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
  defp get_instruction_parameters(program, index, 5), do: {program[index + 1], program[index + 2]}
  defp get_instruction_parameters(program, index, 6), do: {program[index + 1], program[index + 2]}

  defp get_instruction_parameters(program, index, _),
    do: {program[index + 1], program[index + 2], program[index + 3]}

  defp fetch(program, value, mode)
  defp fetch(program, value, 0), do: program[value]
  defp fetch(_program, value, 1), do: value

  defp less_than(first, second) when first < second, do: 1
  defp less_than(_first, _second), do: 0

  defp equals(first, second) when first == second, do: 1
  defp equals(_first, _second), do: 0

  defmodule Parser do
    def parse_array_to_program(input) do
      Enum.with_index(input) |> Enum.map(fn {v, k} -> {k, v} end) |> Map.new()
    end
  end
end
