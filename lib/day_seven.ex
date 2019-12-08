defmodule DaySeven do 
  def execute(input) do
    part_one = AmplificationCircuit.get_maximum_thrust_signal(input)
    [{:one, part_one}, {:two, "Not yet"}]
  end
end
