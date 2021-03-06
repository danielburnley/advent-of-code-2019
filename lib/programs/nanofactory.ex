defmodule Nanofactory do
  def ore_required_for_chemical(reactions, chemical) do
    {reactions, outputs} = Nanofactory.Parser.execute(reactions)

    {_, ore_amount} = calculate_ore_for_reaction(reactions[chemical], reactions, outputs)
    ore_amount
  end

  def fuel_amount_for_ore(reactions, ore_amount) do
    {reactions, outputs} = Nanofactory.Parser.execute(reactions)
    binary_chop_search_for_fuel(reactions, outputs, ore_amount, 1, ore_amount)
  end

  defp binary_chop_search_for_fuel(_reactions, _outputs, _ore_amount, lower, upper)
       when upper - lower <= 1,
       do: lower

  defp binary_chop_search_for_fuel(reactions, outputs, ore_amount, lower, upper) do
    x = round((upper + lower) / 2)

    reactions_for_x = %{reactions | "FUEL" => reaction_for_x_fuel(reactions["FUEL"], x)}

    {_, ore_required} =
      calculate_ore_for_reaction(reactions_for_x["FUEL"], reactions_for_x, outputs)

    difference = ore_amount - ore_required

    cond do
      difference == 0 -> x
      difference > 0 -> binary_chop_search_for_fuel(reactions, outputs, ore_amount, x, upper)
      difference < 0 -> binary_chop_search_for_fuel(reactions, outputs, ore_amount, lower, x)
    end
  end

  def reaction_for_x_fuel(fuel_reaction, x) do
    Map.new(fuel_reaction, fn {k, v} -> {k, v * x} end)
  end

  defp calculate_ore_for_reaction(reaction, reactions, outputs) do
    if Enum.all?(reaction, fn {k, _} -> k == "ORE" || k == :excess end) do
      {reaction[:excess], reaction["ORE"]}
    else
      next_reaction(reaction, reactions, outputs)
      |> calculate_ore_for_reaction(reactions, outputs)
    end
  end

  defp next_reaction(reaction, reactions, outputs) do
    ore = Map.get(reaction, "ORE", 0)

    Map.drop(reaction, ["ORE", :excess])
    |> Enum.reduce(%{:excess => Map.get(reaction, :excess, %{})}, fn {output_chemical,
                                                                      output_amount},
                                                                     acc ->
      reaction_for_input = reactions[output_chemical]

      excess = Map.get(acc, :excess, %{})

      {excess, output_amount} =
        if Map.has_key?(excess, output_chemical) do
          cond do
            excess[output_chemical] == output_amount ->
              {
                Map.drop(excess, [output_chemical]),
                0
              }

            excess[output_chemical] > output_amount ->
              {
                %{excess | output_chemical => excess[output_chemical] - output_amount},
                0
              }

            excess[output_chemical] < output_amount ->
              {
                Map.drop(excess, [output_chemical]),
                output_amount - excess[output_chemical]
              }
          end
        else
          {excess, output_amount}
        end

      times_for_input =
        times_reaction_needed_for_output_amount(output_chemical, output_amount, outputs)

      excess_created = outputs[output_chemical] * times_for_input - output_amount
      excess = put_new_key_in_map_or_add_to_existing(excess, output_chemical, excess_created)
      acc = Map.put(acc, :excess, excess)

      Enum.reduce(reaction_for_input, acc, fn {k, v}, acc2 ->
        total_to_add = v * times_for_input
        put_new_key_in_map_or_add_to_existing(acc2, k, total_to_add)
      end)
    end)
    |> put_new_key_in_map_or_add_to_existing("ORE", ore)
  end

  defp times_reaction_needed_for_output_amount(chemical_required, output_total, outputs) do
    # IO.puts "Chemical required: #{chemical_required} x #{outputs[chemical_required]}"
    # IO.puts "Output total: #{output_total}"
    # IO.puts(output_total / outputs[chemical_required])

    cond do
      output_total == 0 -> 0
      output_total == 1 -> 1
      output_total <= outputs[chemical_required] -> 1
      true -> Float.ceil(output_total / outputs[chemical_required])
    end
  end

  defp put_new_key_in_map_or_add_to_existing(map, key, value) do
    if Map.has_key?(map, key) do
      %{map | key => map[key] + value}
    else
      Map.put(map, key, value)
    end
  end

  defmodule Parser do
    def execute(inputs, reactions \\ %{}, outputs \\ %{})
    def execute([], reactions, outputs), do: {reactions, outputs}

    def execute([input | rest], reactions, outputs) do
      [[reagents, output]] = Regex.scan(~r"(.*) => (.*)", input, capture: :all_but_first)

      reagent_list =
        String.split(reagents, ", ")
        |> Enum.map(&String.split(&1, " "))
        |> Enum.reduce(%{}, fn [num, res], acc -> Map.put(acc, res, String.to_integer(num)) end)

      [quantity, chemical] = String.split(output, " ")
      reactions = Map.put(reactions, chemical, reagent_list)
      outputs = Map.put(outputs, chemical, String.to_integer(quantity))
      execute(rest, reactions, outputs)
    end
  end
end
