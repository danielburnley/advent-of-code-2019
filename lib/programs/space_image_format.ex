defmodule SpaceImageFormat do
  def calculate_checksum(image, width, height) do
    split_input_to_layers(image, width, height) |> calculate_image_checksum
  end

  defp split_input_to_layers(input, width, height) do
    Enum.chunk_every(input, width) |> Enum.chunk_every(height)
  end

  defp calculate_image_checksum(image) do
    check_layer = Enum.min_by(image, &(count_number_in_layer(&1, 0)))
    count_number_in_layer(check_layer, 1) * count_number_in_layer(check_layer, 2)
  end

  def count_number_in_layer(layer, num) do
    count_num_in_row = fn row, num -> Enum.count(row, fn pixel -> pixel == num end) end
    reducer = fn row, acc -> acc + count_num_in_row.(row, num) end 
    Enum.reduce(layer, 0, reducer)
  end
end
