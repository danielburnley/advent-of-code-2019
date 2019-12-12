defmodule DayTen do
  def execute(input) do
    part_one = MonitoringStation.find_maximum_viewable_asteroids(input)
    [{:one, part_one}, {:two, "not yet"}]
  end
end
