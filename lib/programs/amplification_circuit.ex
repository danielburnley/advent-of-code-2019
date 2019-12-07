defmodule AmplificationCircuit do
  def get_maximum_thrust_signal(input) do
    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    possible_combinations = permutations([0,1,2,3,4])

    Enum.map(possible_combinations, &(calculate_thrust_signal(&1, indexed_input))))
  end

  defp calculate_thrust_signal([a, b, c, d, e], indexed_input) do
    # TODO - Calculate output for A with stub, pass forward, some kind of IO processes
  end

  defp permutations([]), do: [[]]
  defp permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]
end
