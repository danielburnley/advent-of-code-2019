defmodule MonitoringStationTest do
  defmodule FindMaximumViewableAsteroids do
    use ExUnit.Case

    test "A single asteroid returns 0" do
      input = [["#", "."], [".", "."]]
      assert MonitoringStation.find_maximum_viewable_asteroids(input) == {{0, 0}, 0}
    end

    test "Two asteroids returns 1" do
      input = [["#", "."], [".", "#"]]
      assert MonitoringStation.find_maximum_viewable_asteroids(input) == {{0, 0}, 1}
    end

    test "Three asteroids returns 2" do
      input = [["#", ".", "."], [".", "#", "."], [".", ".", "#"]]
      assert MonitoringStation.find_maximum_viewable_asteroids(input) == {{1, 1}, 2}
    end

    test "Four asteroids returns 3" do
      input = [["#", ".", "#"], [".", "#", "."], [".", ".", "#"]]
      assert MonitoringStation.find_maximum_viewable_asteroids(input) == {{2, 0}, 3}
    end

    test "Example one" do
      input =
        [
          "......#.#.",
          "#..#.#....",
          "..#######.",
          ".#.#.###..",
          ".#..#.....",
          "..#....#.#",
          "#..#....#.",
          ".##.#..###",
          "##...#..#.",
          ".#....####"
        ]
        |> Enum.map(fn line -> String.graphemes(line) end)

      assert MonitoringStation.find_maximum_viewable_asteroids(input) == {{5, 8}, 33}
    end

    test "Example two" do
      input =
        [
          "#.#...#.#.",
          ".###....#.",
          ".#....#...",
          "##.#.#.#.#",
          "....#.#.#.",
          ".##..###.#",
          "..#...##..",
          "..##....##",
          "......#...",
          ".####.###."
        ]
        |> Enum.map(fn line -> String.graphemes(line) end)

      assert MonitoringStation.find_maximum_viewable_asteroids(input) == {{1, 2}, 35}
    end

    test "Example four" do
      input =
        [
          ".#..##.###...#######",
          "##.############..##.",
          ".#.######.########.#",
          ".###.#######.####.#.",
          "#####.##.#.##.###.##",
          "..#####..#.#########",
          "####################",
          "#.####....###.#.#.##",
          "##.#################",
          "#####.##.###..####..",
          "..######..##.#######",
          "####.##.####...##..#",
          ".#####..#.######.###",
          "##...#.##########...",
          "#.##########.#######",
          ".####.#.###.###.#.##",
          "....##.##.###..#####",
          ".#.#.###########.###",
          "#.#.#.#####.####.###",
          "###.##.####.##.#..##"
        ]
        |> Enum.map(fn line -> String.graphemes(line) end)

      assert MonitoringStation.find_maximum_viewable_asteroids(input) == {{11, 13}, 210}
    end
  end

  defmodule GetVapourisedAsteroids do
    use ExUnit.Case

    test "3 asteroids" do
      input = [
        ".#.",
        ".#.",
        ".#."
      ]

      assert_vapourised(input, [{1, 0}, {1, 2}])
    end

    test "5 asteroids" do
      input = [
        "###",
        ".#.",
        ".#."
      ]

      assert_vapourised(input, [{1, 0}, {2, 0}, {1, 2}, {0, 0}])
    end

    test "7 asteroids" do
      input = [
        "###",
        "###",
        "###"
      ]

      assert_vapourised(input, [
        {1, 0},
        {2, 0},
        {2, 1},
        {2, 2},
        {1, 2},
        {0, 2},
        {0, 1},
        {0, 0}
      ])
    end

    test "Example 1" do
      vapourised =
        [
          ".#..##.###...#######",
          "##.############..##.",
          ".#.######.########.#",
          ".###.#######.####.#.",
          "#####.##.#.##.###.##",
          "..#####..#.#########",
          "####################",
          "#.####....###.#.#.##",
          "##.#################",
          "#####.##.###..####..",
          "..######..##.#######",
          "####.##.####...##..#",
          ".#####..#.######.###",
          "##...#.##########...",
          "#.##########.#######",
          ".####.#.###.###.#.##",
          "....##.##.###..#####",
          ".#.#.###########.###",
          "#.#.#.#####.####.###",
          "###.##.####.##.#..##"
        ]
        |> Enum.map(fn line -> String.graphemes(line) end)
        |> MonitoringStation.get_vapourised_asteroids()

      assert Enum.at(vapourised, 0) == {11, 12}
      assert Enum.at(vapourised, 1) == {12, 1}
      assert Enum.at(vapourised, 200) == {8, 2}
    end

    defp assert_vapourised(input, expected) do
      asteroids =
        Enum.map(input, fn line -> String.graphemes(line) end)
        |> MonitoringStation.get_vapourised_asteroids()

      assert asteroids == expected
    end
  end
end
