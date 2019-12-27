defmodule DayFifteen do
  def execute(input) do
    p_ship = spawn_link(fn -> ship() end)
    p_main = spawn_link(fn -> main() end)
    coordinator = spawn_link(fn -> DayFifteen.FullCoordinator.run(p_ship, p_main) end)

    input_func = fn ->
      send(coordinator, {:next_input, self()})

      next_input =
        receive do
          {:next_input, next_input} -> next_input
        end

      Integer.to_string(next_input)
    end

    output_func = fn out ->
      send(coordinator, {:output, out})
    end

    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    IntcodeComputer.run_program(indexed_input, {input_func, output_func})
  end

  defp main do
    map =
      receive do
        {:map_complete, map} -> map
      end

    IO.puts("Map complete - Beginning to fill with oxygen...")
    :timer.sleep(5000)

    DayFifteen.CalculateStepsToFillOxygen.execute(map)
  end

  defmodule CalculateStepsToFillOxygen do
    def execute(map, steps \\ 0) do
      oxygen_positions =
        Enum.filter(map, fn {_pos, value} -> value == 2 end)
        |> Enum.map(fn {pos, _} -> pos end)

      next_oxygen_positions =
        Enum.flat_map(oxygen_positions, fn pos ->
          DayFifteen.Pathfinder.get_adjacent_locations(pos)
          |> Enum.filter(fn pos ->
            Map.get(map, pos, -1) == 1 or Map.get(map, pos, -1) == :start
          end)
        end)

      map =
        Enum.reduce(next_oxygen_positions, map, fn pos, acc ->
          Map.put(acc, pos, 2)
        end)

      IO.puts("\e[H\e[2J")
      DayFifteen.FullCoordinator.print(map, {0, 0})

      :timer.sleep(250)

      steps = steps + 1

      if Enum.count(map, fn {_pos, value} -> value == 1 or value == :start end) == 0 do
        IO.puts(steps)
      else
        execute(map, steps)
      end
    end
  end

  defmodule FullCoordinator do
    def run(ship, main, current_position \\ {0, 0}, inputs \\ [1])
    def run(ship, main, current_position, []), do: :ok

    def run(ship, main, current_position, [next_input | rest]) do
      receive do
        {:next_input, caller} ->
          send(caller, {:next_input, next_input})
      end

      next_position = move(current_position, next_input)

      output =
        receive do
          {:output, output} -> output
        end

      send(ship, {:put, self(), next_position, output})

      receive do
        :map_put -> :ok
      end

      position =
        case output do
          # hit wall - dont move
          0 -> current_position
          1 -> next_position
          2 -> next_position
        end

      send(ship, {:get_map, self()})

      ship_map =
        receive do
          {:ship_map, map} -> map
        end

      IO.puts("\e[H\e[2J")
      DayFifteen.FullCoordinator.print(ship_map, {0, 0})
      :timer.sleep(100)

      inputs =
        cond do
          Enum.count(rest) > 0 ->
            rest

          true ->
            unknown_locations = DayFifteen.Pathfinder.get_unknown_locations(ship_map)

            if Enum.count(unknown_locations) > 0 do
              next_location =
                Enum.min_by(unknown_locations, fn {x, y} ->
                  {cur_x, cur_y} = position
                  abs(cur_x - x) + abs(cur_y - y)
                end)

              path_to_location = DayFifteen.Pathfinder.get_path(position, next_location, ship_map)
              DayFifteen.Pathfinder.get_inputs_for_path(position, path_to_location)
            else
              send(main, {:map_complete, ship_map})
              []
            end
        end

      run(ship, main, position, inputs)
    end

    defp move({x, y}, 1), do: {x, y + 1}
    # S
    defp move({x, y}, 2), do: {x, y - 1}
    # W
    defp move({x, y}, 3), do: {x - 1, y}
    # E
    defp move({x, y}, 4), do: {x + 1, y}

    def print(ship, current_position) do
      xs = Map.keys(ship) |> Enum.map(fn {x, _} -> x end)
      ys = Map.keys(ship) |> Enum.map(fn {_, y} -> y end)

      min_x = Enum.min(xs)
      max_x = Enum.max(xs)

      min_y = Enum.min(ys)
      max_y = Enum.max(ys)

      Enum.each(max_y..min_y, fn y ->
        IO.puts(
          Enum.map(min_x..max_x, fn x ->
            cond do
              {x, y} == current_position -> :robot
              true -> Map.get(ship, {x, y}, :unknown)
            end
          end)
          |> Enum.map(fn code ->
            case code do
              0 -> "#"
              1 -> "·"
              2 -> "O"
              :robot -> "*"
              :start -> "S"
              :unknown -> " "
            end
          end)
          |> Enum.join("")
        )
      end)
    end
  end

  defp ship(map \\ %{{0, 0} => :start}) do
    receive do
      {:get_map, caller} ->
        send(caller, {:ship_map, map})
        ship(map)

      {:put, caller, position, value} ->
        map = Map.put_new(map, position, value)
        send(caller, :map_put)
        ship(map)
    end
  end
end
