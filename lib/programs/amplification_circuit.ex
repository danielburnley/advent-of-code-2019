defmodule AmplificationCircuit do
  def get_maximum_thrust_signal(input) do
    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    phase_settings = permutations([0, 1, 2, 3, 4])

    Enum.map(phase_settings, &calculate_thrust_signal(&1, indexed_input)) |> Enum.max()
  end

  def get_maximum_thrust_with_feedback(input) do
    indexed_input = IntcodeComputer.Parser.parse_array_to_program(input)
    phase_settings = permutations([5, 6, 7, 8, 9])

    Enum.map(phase_settings, &calculate_thrust_with_feedback(&1, indexed_input)) |> Enum.max()
  end

  defp calculate_thrust_with_feedback(phase_settings, program) do
    inputs = initialize_inputs(phase_settings)
    input_functions = initialize_input_functions(inputs)
    connections = initialize_connections(inputs)
    outputs = initialize_outputs(connections)
    run_amplifiers(self(), program, input_functions, outputs)
    {_, _, _, _, e_connection} = connections

    receive do
      :e ->
        send(e_connection, {:last, self()})
    end

    receive do
      {:last_output, output} -> output
    end
  end

  defp initialize_inputs([a, b, c, d, e]) do
    {
      spawn_input_for([a, 0]),
      spawn_input_for([b]),
      spawn_input_for([c]),
      spawn_input_for([d]),
      spawn_input_for([e])
    }
  end

  defp initialize_input_functions({a, b, c, d, e}) do
    {
      fn -> get_input(a) end,
      fn -> get_input(b) end,
      fn -> get_input(c) end,
      fn -> get_input(d) end,
      fn -> get_input(e) end
    }
  end

  defp initialize_connections({a, b, c, d, e}) do
    {
      spawn_connection_to(b),
      spawn_connection_to(c),
      spawn_connection_to(d),
      spawn_connection_to(e),
      spawn_connection_to(a)
    }
  end

  defp initialize_outputs({a, b, c, d, e}) do
    {
      fn output -> send(a, {:send, output}) end,
      fn output -> send(b, {:send, output}) end,
      fn output -> send(c, {:send, output}) end,
      fn output -> send(d, {:send, output}) end,
      fn output -> send(e, {:send, output}) end
    }
  end

  defp run_amplifiers(
         caller,
         program,
         {a_in, b_in, c_in, d_in, e_in},
         {a_out, b_out, c_out, d_out, e_out}
       ) do
    spawn_amplifier(caller, :a, program, a_in, a_out)
    spawn_amplifier(caller, :b, program, b_in, b_out)
    spawn_amplifier(caller, :c, program, c_in, c_out)
    spawn_amplifier(caller, :d, program, d_in, d_out)
    spawn_amplifier(caller, :e, program, e_in, e_out)
  end

  defp spawn_input_for(initial_input) do
    spawn_link(fn -> input_getter(initial_input) end)
  end

  defp spawn_connection_to(computer_input) do
    spawn_link(fn -> connection_to(computer_input) end)
  end

  defp spawn_amplifier(caller, amplifier_id, program, input, output) do
    spawn_link(fn ->
      IntcodeComputer.run_program(program, {input, output})
      send(caller, amplifier_id)
    end)
  end

  defp connection_to(input, output_log \\ []) do
    receive do
      {:send, output} ->
        send(input, {:put, output})
        connection_to(input, [output | output_log])

      {:last, caller} ->
        send(caller, {:last_output, hd(output_log)})
    end
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

    captured_output =
      receive do
        [output] -> output
      end

    captured_output
  end

  defp permutations([]), do: [[]]

  defp permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

  def input_getter([]) do
    receive do
      {:put, new_input} ->
        input_getter([new_input])
    end
  end

  def input_getter(inputs) do
    receive do
      {:get, caller} ->
        [input | rest] = inputs
        send(caller, {:ok, Integer.to_string(input)})
        input_getter(rest)

      {:put, new_input} ->
        inputs = inputs ++ [new_input]
        input_getter(inputs)
    end
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
