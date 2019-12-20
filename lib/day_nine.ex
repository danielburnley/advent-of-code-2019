defmodule DayNine do
  def execute(input) do
    #part_one(input)
    part_two(input)
    [{:one, "sdfgh"}, {:two, "fgh"}]
  end

  defp part_one(input) do
    inputter = fn -> "1\n" end
    outputter = fn output -> IO.puts(output) end
    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    IntcodeComputer.run_program(indexed_input, { inputter, outputter })
  end

  defp part_two(input) do
    inputter = fn -> "2\n" end
    outputter = fn output -> IO.puts(output) end
    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    IntcodeComputer.run_program(indexed_input, { inputter, outputter })
  end
end
