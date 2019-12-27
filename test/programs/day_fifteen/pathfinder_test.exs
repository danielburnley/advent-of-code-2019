defmodule PathfinderTest do
  defmodule GetInputsForPath do
    use ExUnit.Case

    test "Given an input N" do
      start_pos = {0, 0}
      path = [{0, 1}]

      assert DayFifteen.Pathfinder.get_inputs_for_path(start_pos, path) == [1]
    end

    test "Given an input S" do
      start_pos = {0, 0}
      path = [{0, -1}]

      assert DayFifteen.Pathfinder.get_inputs_for_path(start_pos, path) == [2]
    end

    test "Given an input W" do
      start_pos = {0, 0}
      path = [{-1, 0}]

      assert DayFifteen.Pathfinder.get_inputs_for_path(start_pos, path) == [3]
    end

    test "Given an input E" do
      start_pos = {0, 0}
      path = [{1, 0}]

      assert DayFifteen.Pathfinder.get_inputs_for_path(start_pos, path) == [4]
    end

    test "Given two inputs N,E" do
      start_pos = {0, 0}
      path = [{0, 1}, {1, 1}]

      assert DayFifteen.Pathfinder.get_inputs_for_path(start_pos, path) == [1, 4]
    end

    # N
    defp move({x, y}, 1), do: {x, y + 1}
    # S
    defp move({x, y}, 2), do: {x, y - 1}
    # W
    defp move({x, y}, 3), do: {x - 1, y}
    # E
    defp move({x, y}, 4), do: {x + 1, y}
  end

  defmodule GetPath do
    use ExUnit.Case

    test "Example One: One away returns desination" do
      ship = %{{0, 1} => 1}
      position = {0, 0}
      destination = {0, 1}

      assert DayFifteen.Pathfinder.get_path(position, destination, ship) == [{0, 1}]
    end

    test "Example Two: One away returns desination" do
      ship = %{{0, -1} => 1}
      position = {0, 0}
      destination = {0, -1}

      assert DayFifteen.Pathfinder.get_path(position, destination, ship) == [{0, -1}]
    end

    test "Two away returns path" do
      ship = %{{0, -1} => 1, {0, -2} => 1}
      position = {0, 0}
      destination = {0, -2}

      assert DayFifteen.Pathfinder.get_path(position, destination, ship) == [{0, -1}, {0, -2}]
    end

    test "Three away returns path" do
      ship = %{{0, -1} => 1, {0, -2} => 1, {0, -3} => 1}
      position = {0, 0}
      destination = {0, -3}

      assert DayFifteen.Pathfinder.get_path(position, destination, ship) == [
               {0, -1},
               {0, -2},
               {0, -3}
             ]
    end

    test "Going to an unknown location" do
      ship = %{{0, 1} => 1}
      position = {0, 0}
      destination = {0, 2}

      assert DayFifteen.Pathfinder.get_path(position, destination, ship) == [{0, 1}, {0, 2}]
    end
  end

  defmodule GetPossibleMoves do
    use ExUnit.Case

    test "Given a location surrounded by only one open square" do
      ship = %{{0, 1} => 0, {0, -1} => 0, {-1, 0} => 0, {1, 0} => 1}
      position = {0, 0}

      assert DayFifteen.Pathfinder.get_possible_moves(ship, position) == [{1, 0}]
    end

    test "Given a location surrounded by four open squares" do
      ship = %{{0, 1} => 1, {0, -1} => 1, {-1, 0} => 1, {1, 0} => 1}
      position = {0, 0}

      assert DayFifteen.Pathfinder.get_possible_moves(ship, position) == [
               {-1, 0},
               {0, -1},
               {0, 1},
               {1, 0}
             ]
    end
  end

  defmodule GetUnknownLocations do
    use ExUnit.Case

    test "Given a single location" do
      input = %{{0, 0} => 1}
      expected_locations = MapSet.new([{0, 1}, {0, -1}, {1, 0}, {-1, 0}])

      assert DayFifteen.Pathfinder.get_unknown_locations(input) == expected_locations
    end

    test "Given a multiple location" do
      input = %{{0, 0} => 1, {0, 1} => 1}
      expected_locations = MapSet.new([{0, -1}, {1, 0}, {-1, 0}, {0, 2}, {1, 1}, {-1, 1}])

      assert DayFifteen.Pathfinder.get_unknown_locations(input) == expected_locations
    end

    test "Given 3 locations with two walls" do
      input = %{{0, 0} => 1, {0, 1} => 0, {0, -1} => 0}
      expected_locations = MapSet.new([{1, 0}, {-1, 0}])

      assert DayFifteen.Pathfinder.get_unknown_locations(input) == expected_locations
    end
  end
end
