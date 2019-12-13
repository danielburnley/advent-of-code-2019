defmodule DayTen do
  def execute(input) do
    {_, part_one} = MonitoringStation.find_maximum_viewable_asteroids(input)
    {x, y} = MonitoringStation.get_vapourised_asteroids(input) |> Enum.at(199)
    [{:one, part_one}, {:two, 100 * x + y}]
  end
end
