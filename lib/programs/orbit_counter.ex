defmodule OrbitCounter do
  def execute(input) do
    orbits =
      Enum.map(input, &input_to_relationship(&1))
      |> map_orbits_for_relationships

    satellites = Map.keys(orbits)
    reducer = fn satellite, acc -> count_orbits_for_satellite(satellite, orbits) + acc end
    Enum.reduce(satellites, 0, reducer)
  end

  defp count_orbits_for_satellite(satellite, orbits, total \\ 0)
  defp count_orbits_for_satellite("COM", _, total), do: total

  defp count_orbits_for_satellite(satellite, orbits, total) do
    count_orbits_for_satellite(orbits[satellite], orbits, total + 1)
  end

  defp input_to_relationship(input) do
    [body, satellite] = String.split(input, ")")
    {body, satellite}
  end

  defp map_orbits_for_relationships(relationships, orbits \\ %{})
  defp map_orbits_for_relationships([], orbits), do: orbits

  defp map_orbits_for_relationships([{body, satellite} | rest], orbits) do
    orbits = Map.put(orbits, satellite, body)
    map_orbits_for_relationships(rest, orbits)
  end
end
