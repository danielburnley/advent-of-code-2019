defmodule SpaceImageFormat do
  def calculate_checksum(image, width, height) do
    split_input_to_layers(image, width, height) |> SpaceImageFormat.Checksum.calculate()
  end

  def calculate_image(image, width, height) do
    split_input_to_layers(image, width, height)
    |> SpaceImageFormat.GenerateImage.build_image_from_layers(width, height)
  end

  def split_input_to_layers(input, width, height) do
    Enum.chunk_every(input, width) |> Enum.chunk_every(height)
  end

  defmodule GenerateImage do
    def build_image_from_layers(layers, width, height) do
      x_coords = for x <- 0..(width - 1), do: x
      y_coords = for y <- 0..(height - 1), do: y

      Enum.map(y_coords, fn y ->
        Enum.map(x_coords, fn x ->
          get_pixel_at(layers, {x, y})
        end)
      end)
      |> Enum.map(fn row ->
        Enum.map(row, fn num ->
          display_integer(num)
        end)
      end)
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.join("\n")
    end

    defp get_pixel_at(layers, {x, y}) do
      Enum.map(layers, fn layer -> Enum.at(layer, y) |> Enum.at(x) end)
      |> Enum.find(2, fn num -> num == 0 or num == 1 end)
    end

    defp display_integer(0), do: " "
    defp display_integer(1), do: "X"
    defp display_integer(2), do: " "
  end

  defmodule Checksum do
    def calculate(image) do
      check_layer = Enum.min_by(image, &count_number_in_layer(&1, 0))
      count_number_in_layer(check_layer, 1) * count_number_in_layer(check_layer, 2)
    end

    def count_number_in_layer(layer, num) do
      count_num_in_row = fn row, num -> Enum.count(row, fn pixel -> pixel == num end) end
      reducer = fn row, acc -> acc + count_num_in_row.(row, num) end
      Enum.reduce(layer, 0, reducer)
    end
  end
end
