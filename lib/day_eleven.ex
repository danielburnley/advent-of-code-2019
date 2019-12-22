defmodule DayEleven do
  def execute(input) do
    # part_two(input)
    output_one = part_one(input)
    IO.inspect(output_one)
    [{:one, "adsd"}, {:two, "fgh"}]
  end

  defp part_one(input) do
    hull = spawn_link(fn -> DayEleven.Hull.run end)
    robit = spawn_link(fn -> DayEleven.Robot.start end)

    inputter = fn -> 
      send(robit, {:position, self()})
      position = receive do
        {:position, position} -> position
      end

      send(hull, {:get, position, self()})

      receive do
        {:colour, colour} -> Integer.to_string(colour)
      end
    end

    coordinator = spawn_link(fn -> DayEleven.Coordinator.run(hull, robit) end)

    output = fn output -> 
      send(coordinator, {:output, output, self()}) 
      receive do
        :ack -> :ack
      end
    end

    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    IntcodeComputer.run_program(indexed_input, {inputter, output})

    send(hull, {:painted, self()})

    painted_points = receive do
      {:painted, painted} -> painted
    end

    IO.puts Map.keys(painted_points) |> Enum.count
  end

  defmodule Coordinator do
    def run(hull, robot) do
      {paint_colour, caller} = receive do
        {:output, colour, caller} -> {colour, caller}
      end


      send(robot, {:position, self()})

      current_position = receive do
        {:position, position} -> position
      end

      send(hull, {:paint, current_position, paint_colour})

      send(caller, :ack)

      {new_direction, caller} = receive do
        {:output, direction, caller} -> { direction, caller }
      end

      send(robot, {:move, new_direction})

      send(caller, :ack)
      run(hull, robot)
    end
  end

  defmodule Hull do
    def run(hull \\ %{}) do
      receive do
        {:paint, pos, paint} -> 
          hull = Map.put(hull, pos, paint)
          run(hull)
        {:get, pos, caller} -> 
          send(caller, {:colour, Map.get(hull, pos, 0)})
          run(hull)
        {:painted, caller} ->
          send(caller, {:painted, hull})
      end
    end
  end

  defmodule Robot do
    def start(position \\ {0, 0}, direction \\ 0) do
      receive do
        {:move, movement_direction} -> 
          new_direction = change_direction(direction, movement_direction)
          new_position = move(position, new_direction)
          start(new_position, new_direction)
        {:position, caller} -> 
          send(caller, {:position, position})
          start(position, direction)
      end
    end

    defp change_direction(0, 0), do: 3
    defp change_direction(cur, 0), do: cur - 1
    defp change_direction(cur, 1), do: rem(cur + 1, 4)

    defp move({x, y}, 0), do: {x, y + 1}
    defp move({x, y}, 1), do: {x + 1, y}
    defp move({x, y}, 2), do: {x, y - 1}
    defp move({x, y}, 3), do: {x - 1, y}
  end
end
