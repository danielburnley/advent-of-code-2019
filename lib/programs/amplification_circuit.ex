defmodule AmplificationCircuit do
  def get_maximum_thrust_signal(input) do
    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    phase_settings = permutations([0,1,2,3,4])

    Enum.map(phase_settings, &(calculate_thrust_signal(&1, indexed_input))) |> Enum.max
  end

  defp calculate_thrust_signal([a, b, c, d, e], program) do
    a_thrust = calculate_thrust_for_computer(a, 0, program)
    b_thrust = calculate_thrust_for_computer(b, a_thrust, program)
    c_thrust = calculate_thrust_for_computer(c, b_thrust, program)
    d_thrust = calculate_thrust_for_computer(d, c_thrust, program)
    e_thrust = calculate_thrust_for_computer(e, d_thrust, program)

    e_thrust
  end

  defp calculate_thrust_for_computer(first_input, second_input, program) do
    inputter = spawn_link(fn -> input_getter([first_input, second_input]) end)
    outputter = spawn_link(fn -> capture_output() end)

    input = fn -> get_input(inputter) end
    output = fn output -> send(outputter, {:output, output}) end

    IntcodeComputer.run_program(program, {input, output})
    
    send(outputter, {:return, self()})
    captured_output = receive do
      [output] -> output
    end

    captured_output
  end

  defp permutations([]), do: [[]]
  defp permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]

  defp input_getter([]), do: :ok
  defp input_getter([input|rest]) do
    receive do
      {:get, caller} -> send(caller, {:ok, Integer.to_string(input)})
    end

    input_getter(rest)
  end

  defp get_input(inputter) do
    send(inputter, {:get, self()})
    receive do
      {:ok, input} -> input
    end
  end

  defp capture_output(captured_output \\ []) do
    receive do
      {:output, output} -> capture_output([output | captured_output])
      {:return, caller} -> send(caller, captured_output)
    end
  end
end
