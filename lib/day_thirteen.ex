defmodule DayThirteen do
  def execute(input) do
    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    output_one = part_one(indexed_input)
    [{:one, "adsd"}, {:two, "fgh"}]
  end

  defp part_one(input) do
    screen = spawn_link(fn -> DayThirteen.Screen.run end)
    output_buffer = spawn_link(fn -> output_buffer(screen) end)

    inputter = fn -> "1\n" end
    outputter = fn output -> send(output_buffer, {:output, output}) end
    IntcodeComputer.run_program(input, {inputter, outputter})

    send(screen, {:print, self()})
  end

  defmodule Screen do
    def run(pixels \\ %{}) do
      receive do
        {:display, {x, y, id}} ->
          run(Map.put(pixels, {x, y}, id))
        {:print, caller} -> IO.puts(Map.values(pixels) |> Enum.count(fn x -> x == 2 end))
      end
    end
  end

  defp output_buffer(screen, buffer \\ [])
  defp output_buffer(screen, [id,y,x]) do
    send(screen, {:display, {x, y, id}})

    output_buffer(screen, [])
  end

  defp output_buffer(screen, buffer) do
    receive do
      {:output, value} -> output_buffer(screen, [value|buffer])
    end
  end
end
