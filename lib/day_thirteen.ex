defmodule DayThirteen do
  def execute(input) do
    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    output_one = part_one(indexed_input)
    output_two = part_two(indexed_input)
    [{:one, "adsd"}, {:two, "fgh"}]
  end

  defp part_one(input) do
    screen = spawn_link(fn -> DayThirteen.Screen.run() end)
    output_buffer = spawn_link(fn -> output_buffer(screen) end)

    inputter = fn -> "1\n" end
    outputter = fn output -> send(output_buffer, {:output, output}) end
    IntcodeComputer.run_program(input, {inputter, outputter})

    send(screen, {:print_blocks})
  end

  defp part_two(input) do
    input = %{input | 0 => 2}
    screen = spawn_link(fn -> DayThirteen.Screen.run() end)
    output_buffer = spawn_link(fn -> output_buffer(screen) end)

    inputter = fn ->
      send(screen, {:screen_to_lines, self()})

      receive do
        lines -> IO.puts(Enum.join(lines, "\n"))
      end

      send(screen, {:ball_and_paddle_positions, self()})

      difference =
        receive do
          {ball, paddle} ->
            {bx, _} = ball
            {px, _} = paddle

            bx - px
        end

      cond do
        difference == 0 -> "0"
        difference > 0 -> "1"
        difference < 0 -> "-1"
      end
    end

    outputter = fn output -> send(output_buffer, {:output, output}) end
    IntcodeComputer.run_program(input, {inputter, outputter})

    send(screen, {:screen_to_lines, self()})

    receive do
      lines -> :ok
    end

    send(screen, {:print_score})
  end

  defmodule Screen do
    def run(pixels \\ %{}) do
      receive do
        {:score, score} ->
          run(Map.put(pixels, :score, score))

        {:display, {x, y, id}} ->
          run(Map.put(pixels, {x, y}, id))

        {:screen_to_lines, caller} ->
          xs = Map.delete(pixels, :score) |> Map.keys() |> Enum.map(fn {x, _} -> x end)
          ys = Map.delete(pixels, :score) |> Map.keys() |> Enum.map(fn {_, y} -> y end)

          min_x = Enum.min(xs)
          max_x = Enum.max(xs)

          min_y = Enum.min(ys)
          max_y = Enum.max(ys)

          lines =
            Enum.map(min_y..max_y, fn y ->
              Enum.map(min_x..max_x, fn x ->
                Map.get(pixels, {x, y}, 0)
              end)
              |> Enum.map(fn tile ->
                case tile do
                  0 -> " "
                  1 -> "|"
                  2 -> "X"
                  3 -> "-"
                  4 -> "O"
                end
              end)
              |> Enum.join("")
            end)

          send(caller, lines ++ ["Score: #{pixels[:score]}"])
          run(pixels)

        {:ball_and_paddle_positions, caller} ->
          {ball_position, _} = Enum.find(pixels, fn {_, id} -> id == 4 end)
          {paddle_position, _} = Enum.find(pixels, fn {_, id} -> id == 3 end)

          send(caller, {ball_position, paddle_position})
          run(pixels)

        {:print_blocks} ->
          IO.puts(Map.delete(pixels, :score) |> Map.values() |> Enum.count(fn x -> x == 2 end))

        {:print_score} ->
          IO.puts("Final score: #{pixels[:score]}")
      end
    end
  end

  defp output_buffer(screen, buffer \\ [])

  defp output_buffer(screen, [score, 0, -1]) do
    send(screen, {:score, score})
    output_buffer(screen)
  end

  defp output_buffer(screen, [id, y, x]) do
    send(screen, {:display, {x, y, id}})

    output_buffer(screen, [])
  end

  defp output_buffer(screen, buffer) do
    receive do
      {:output, value} -> output_buffer(screen, [value | buffer])
    end
  end
end
