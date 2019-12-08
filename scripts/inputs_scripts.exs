defmodule Test do
  def input_getter(inputs) do
    receive do
      {:get, caller} -> 
        [input|rest] = inputs
        send(caller, {:ok, Integer.to_string(input)})
        input_getter(rest)
      {:put, new_input} -> 
        IO.puts("Put #{new_input}")
        inputs = inputs ++ [new_input]
        input_getter(inputs)
    end
  end
end

inputter = spawn_link(fn -> Test.input_getter([]) end)

send(inputter, {:put, 10})
send(inputter, {:get, self()})
receive do
  {:ok, num} -> IO.puts num
end