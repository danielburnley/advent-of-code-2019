defmodule Input do 
  def get(day) do
    File.read!("lib/inputs/#{day}.txt") |> String.trim()
  end
end
