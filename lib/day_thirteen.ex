defmodule DayThirteen do
  def execute(input) do
    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    output_one = part_one(indexed_input)
    [{:one, "adsd"}, {:two, "fgh"}]
  end

  defp part_one(input) do
    inputter = fn -> "1\n" end
    outputter = fn output -> IO.puts(output) end
    IntcodeComputer.run_program(input, {inputter, outputter})
  end
end
