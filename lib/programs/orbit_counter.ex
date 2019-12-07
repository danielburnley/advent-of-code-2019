defmodule OrbitCounter do
  def count_orbits(input) do
    orbits =
      Enum.map(input, &input_to_relationship(&1))
      |> map_orbits_for_relationships

    satellites = Map.keys(orbits)
    reducer = fn satellite, acc -> count_orbits_for_satellite(satellite, orbits) + acc end
    Enum.reduce(satellites, 0, reducer)
  end

  def count_transfers(input) do
    orbits =
      Enum.map(input, &input_to_relationship(&1))
      |> map_orbits_for_relationships

    calculate_total_transfers(orbits["YOU"], orbits["SAN"], orbits)
  end

  defp calculate_total_transfers(source, destination, orbits, total_from_destination \\ 0) do
    {success, total} = transfers_to_body(source, destination, orbits)

    total =
      case success do
        :ok ->
          total + total_from_destination

        :error ->
          calculate_total_transfers(
            source,
            orbits[destination],
            orbits,
            total_from_destination + 1
          )
      end
  end

  defp transfers_to_body(source, destination, orbits, total \\ 0)
  defp transfers_to_body(nil, _, _, _), do: {:error, -1}
  defp transfers_to_body(destination, destination, _, total), do: {:ok, total}

  defp transfers_to_body(source, destination, orbits, total) do
    transfers_to_body(orbits[source], destination, orbits, total + 1)
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
