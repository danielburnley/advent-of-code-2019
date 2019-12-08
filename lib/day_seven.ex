defmodule DaySeven do
  def execute(input) do
    part_one = AmplificationCircuit.get_maximum_thrust_signal(input)
    part_two = AmplificationCircuit.get_maximum_thrust_with_feedback(input)
    [{:one, part_one}, {:two, part_two}]
  end
end
