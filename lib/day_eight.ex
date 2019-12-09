defmodule DayEight do
  def execute(input) do
    part_one = SpaceImageFormat.calculate_checksum(input, 25, 6)
    [{:one, part_one}, {:two, "Net yet"}]
  end

end
