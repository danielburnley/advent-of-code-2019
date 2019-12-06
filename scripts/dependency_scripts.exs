defmodule Test do
  def execute_input_getter(input_getter) do
    output = input_getter.() |> String.trim("\n")
    IO.puts "You write: #{output}"
  end
end

input_func = fn -> IO.gets("Input pls \n") end
stub_input_func = fn -> "Meow" end

Test.execute_input_getter(stub_input_func)