defmodule DayThreeTest do
  use ExUnit.Case

  test "1,1" do
    first = "R1,U1"
    second = "U1,R1"
    output = DayThree.execute([first, second])

    assert output[:one] == 2
  end

  test "-1,-1" do
    first = "L1,D1"
    second = "D1,L1"
    output = DayThree.execute([first, second])

    assert output[:one] == 2
  end
end
