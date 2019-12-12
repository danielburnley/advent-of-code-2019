defmodule DayEight do
  def execute(input) do
    part_one = SpaceImageFormat.calculate_checksum(input, 25, 6)
    part_two = SpaceImageFormat.calculate_image(input, 25, 6)
    [{:one, part_one}, {:two, "\n#{part_two}"}]
  end
end
