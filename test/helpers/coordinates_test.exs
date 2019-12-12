defmodule CoordinatesTest do
  use ExUnit.Case

  test "Calculate intersecting points horizontally" do
    assert Coordinates.calculate_intersecting_points({0, 0}, {5, 0}) == [
             {4, 0},
             {3, 0},
             {2, 0},
             {1, 0}
           ]
  end

  test "Calculate intersecting points reversed horizontally" do
    assert Coordinates.calculate_intersecting_points({5, 0}, {0, 0}) == [
             {1, 0},
             {2, 0},
             {3, 0},
             {4, 0}
           ]
  end

  test "Calculate intersecting diagonally" do
    assert Coordinates.calculate_intersecting_points({0, 0}, {5, 5}) == [
             {4, 4},
             {3, 3},
             {2, 2},
             {1, 1}
           ]
  end

  test "Calculate intersecting reversed diagonally" do
    assert Coordinates.calculate_intersecting_points({5, 5}, {0, 0}) == [
             {1, 1},
             {2, 2},
             {3, 3},
             {4, 4}
           ]
  end

  test "Calculate intersecting on a slope" do
    assert Coordinates.calculate_intersecting_points({0, 0}, {10, 2}) == [{5, 1}]
  end

  test "Calculate intersecting on a reversed slope" do
    assert Coordinates.calculate_intersecting_points({10, 2}, {0, 0}) == [{5, 1}]
  end

  test "Calculate intersecting on a vertical line" do
    assert Coordinates.calculate_intersecting_points({0, 0}, {0, 5}) == [
             {0, 4},
             {0, 3},
             {0, 2},
             {0, 1}
           ]
  end

  test "Calculate intersecting on a reversed vertical line" do
    assert Coordinates.calculate_intersecting_points({0, 5}, {0, 0}) == [
             {0, 1},
             {0, 2},
             {0, 3},
             {0, 4}
           ]
  end
end
