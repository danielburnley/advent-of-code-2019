defmodule DayTwo do
  def execute(input) do
    indexed_input = Enum.with_index(input) |> Enum.map(fn {v, k} -> {k, v} end) |> Map.new()

    [{:one, run_part_one(indexed_input)}, {:two, run_part_two(indexed_input)}]
  end

  defp run_part_one(program) do
    IntcodeComputer.run_program(%{program | 1 => 12, 2 => 2})[0]
  end

  defp run_part_two(program) do
    elements = 1..99
    inputs = for x <- elements, y <- elements, do: [x, y]
    [noun, verb] = run_part_two(program, inputs, {})
    100 * noun + verb
  end

  defp run_part_two(_, _, {inputs, 19_690_720}), do: inputs

  defp run_part_two(program, [inputs | rest], _) do
    [a, b] = inputs
    output = IntcodeComputer.run_program(%{program | 1 => a, 2 => b})[0]
    run_part_two(program, rest, {inputs, output})
  end
end
