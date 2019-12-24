defmodule NanofactoryTest do
  defmodule OreCaculatorTests do
    use ExUnit.Case

    test "A single input produces correct number of ore" do
      input = ["9 ORE => 1 FUEL"]

      assert Nanofactory.ore_required_for_chemical(input, "FUEL") == 9
    end

    test "Example One: A single chain produces the correct number of ore" do
      input = [
        "10 ORE => 1 A",
        "1 A => 1 FUEL"
      ]

      assert Nanofactory.ore_required_for_chemical(input, "FUEL") == 10
    end

    test "Example Two: A single chain produces the correct number of ore" do
      input = [
        "20 ORE => 1 B",
        "1 B => 1 FUEL"
      ]

      assert Nanofactory.ore_required_for_chemical(input, "FUEL") == 20
    end

    test "Example one: Two inputs with a single chain" do
      input = [
        "10 ORE => 1 A",
        "20 ORE => 1 B",
        "1 A, 1 B => 1 FUEL"
      ]
      
      assert Nanofactory.ore_required_for_chemical(input, "FUEL") == 30
    end

    test "Example one: Two inputs with a multiple chains, no excess" do
      input = [
        "10 ORE => 1 A",
        "20 ORE => 1 B",
        "1 A, 1 B => 1 C",
        "1 A, 1 B => 1 D",
        "1 C, 1 D => 1 FUEL"
      ]
      
      assert Nanofactory.ore_required_for_chemical(input, "FUEL") == 60
    end

    test "One input which requires excess" do
      input = [
        "10 ORE => 2 A",
        "3 A => 1 FUEL"
      ]
      
      assert Nanofactory.ore_required_for_chemical(input, "FUEL") == 20
    end

    test "One input with no chain, one input with chain" do
      input = [
        "10 ORE => 1 A",
        "20 ORE => 1 B",
        "1 A, 1 B => 1 C",
        "1 A, 1 C => 1 FUEL"
      ]

      assert Nanofactory.ore_required_for_chemical(input, "FUEL") == 40
    end

    @tag focus: true
    test "Input with excess overrides additional" do
      input = [
        "10 ORE => 2 A",
        "20 ORE => 1 B",
        "1 A, 1 B => 1 C",
        "1 A, 1 C => 1 FUEL"
      ]

      assert Nanofactory.ore_required_for_chemical(input, "FUEL") == 30
    end
  end

  defmodule ParserTest do
    use ExUnit.Case

    test "Parsing a single reaction returns the correct reagents and results" do
      input = "9 ORE => 1 FUEL"

      {reactions, outputs} = Nanofactory.Parser.execute([input])

      assert reactions == %{"FUEL" => %{"ORE" => 9}}
      assert outputs == %{"FUEL" => 1}
    end

    test "Parsing a single reaction with multiple parts returns the correct values" do
      input = "9 ORE, 10 A => 1 FUEL"

      {reactions, outputs} = Nanofactory.Parser.execute([input])

      assert reactions == %{"FUEL" => %{"ORE" => 9, "A" => 10}}
      assert outputs == %{"FUEL" => 1}
    end

    test "Parsing a multiple reactions returns the correct reagents and results" do
      input = [
        "9 ORE => 5 A",
        "10 A => 1 FUEL"
      ]

      {reactions, outputs} = Nanofactory.Parser.execute(input)

      assert reactions == %{
        "FUEL" => %{"A" => 10},
        "A" => %{"ORE" => 9}
      }

      assert outputs == %{
        "FUEL" => 1,
        "A" => 5
      }
    end
  end
end
