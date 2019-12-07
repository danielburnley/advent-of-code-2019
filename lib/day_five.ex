defmodule DayFive do
  def execute(input) do
    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    [{:one, run_part_one(indexed_input)}, {:two, run_part_two(indexed_input)}]
  end

  defp run_part_one(program) do
    outputter = spawn_link(fn -> capture_output() end)
    output = fn output -> send(outputter, {:output, output}) end
    IntcodeComputer.run_program(program, {fn -> "1\n" end, output})
    send(outputter, {:return, self()})

    receive do
      [final | _] -> final
    end
  end

  defp run_part_two(program) do
    program
  end

  defp capture_output(captured_output \\ []) do
    receive do
      {:output, output} -> capture_output([output | captured_output])
      {:return, caller} -> send(caller, captured_output)
    end
  end
end
