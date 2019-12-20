defmodule MoonMotionSimulatorTest do
  use ExUnit.Case

  test "Given 0 steps -> Return initial positions" do
    inputs = [
      {0, 0, 0},
      {1, 1, 1},
      {2, 2, 2},
      {3, 3, 3}
    ]

    expected = [
      {{0, 0, 0}, {0, 0, 0}},
      {{1, 1, 1}, {0, 0, 0}},
      {{2, 2, 2}, {0, 0, 0}},
      {{3, 3, 3}, {0, 0, 0}}
    ]

    assert_motion_at_step_is(inputs, 0, expected)
  end

  test "Given 1 steps -> Return first positions" do
    inputs = [
      {0, 0, 0},
      {1, 1, 1},
      {2, 2, 2},
      {3, 3, 3}
    ]

    expected = [
      {{3, 3, 3}, {3, 3, 3}},
      {{2, 2, 2}, {1, 1, 1}},
      {{1, 1, 1}, {-1, -1, -1}},
      {{0, 0, 0}, {-3, -3, -3}}
    ]

    assert_motion_at_step_is(inputs, 1, expected)
  end

  test "Example 1" do
    inputs = [
      {-1, 0, 2},
      {2, -10, -7},
      {4, -8, 8},
      {3, 5, -1}
    ]

    expected = [
      {{2, -1, 1}, {3, -1, -1}},
      {{3, -7, -4}, {1, 3, 3}},
      {{1, -7, 5}, {-3, 1, -3}},
      {{2, 2, 0}, {-1, -3, 1}}
    ]

    assert_motion_at_step_is(inputs, 1, expected)

    expected_two = [
      {{5, -3, -1}, {3, -2, -2}},
      {{1, -2, 2}, {-2, 5, 6}},
      {{1, -4, -1}, {0, 3, -6}},
      {{1, -4, 2}, {-1, -6, 2}}
    ]

    assert_motion_at_step_is(inputs, 2, expected_two)
  end

  defp assert_motion_at_step_is(input, step, expected) do
    output = MoonMotionSimulator.get_positions_at_step(input, step)

    assert output == expected
  end
end
