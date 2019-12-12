defmodule MonitoringStationTest do
  use ExUnit.Case

  test "A single asteroid returns 0" do
    input = [["#", "."], [".", "."]]
    assert MonitoringStation.find_maximum_viewable_asteroids(input) == 0
  end

  test "Two asteroids returns 1" do
    input = [["#", "."], [".", "#"]]
    assert MonitoringStation.find_maximum_viewable_asteroids(input) == 1
  end

  test "Three asteroids returns 2" do
    input = [["#", ".", "."], [".", "#", "."], [".", ".", "#"]]
    assert MonitoringStation.find_maximum_viewable_asteroids(input) == 2
  end

  test "Four asteroids returns 3" do
    input = [["#", ".", "#"], [".", "#", "."], [".", ".", "#"]]
    assert MonitoringStation.find_maximum_viewable_asteroids(input) == 3
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

    assert MonitoringStation.find_maximum_viewable_asteroids(input) == 33
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

    assert MonitoringStation.find_maximum_viewable_asteroids(input) == 35
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

    assert MonitoringStation.find_maximum_viewable_asteroids(input) == 210
  end
end
