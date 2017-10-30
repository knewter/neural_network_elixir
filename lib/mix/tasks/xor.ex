defmodule Mix.Tasks.Xor do
  @moduledoc """
  Mix task to run the neural network for xor.
  """

  use Mix.Task

  alias NeuralNetwork.{Network, Trainer, Layer, Neuron}
  @shortdoc "Run the neural network app"

  def run(_args) do
    #epoch_count = 1
    epoch_count = 10_000

    IO.puts ""

    {:ok, network_pid} = Network.start_link([2,2,1])
    Trainer.train(network_pid, training_data(), %{epochs: epoch_count, log_freqs: 1000})
    IO.puts "**************************************************************"
    IO.puts ""
    IO.puts "== XOR =="
    examine(network_pid, [0, 0])
    examine(network_pid, [0, 1])
    examine(network_pid, [1, 0])
    examine(network_pid, [1, 1])
  end

  def training_data do
    [
      %{input: [0,0], output: [0]},
      %{input: [0,1], output: [1]},
      %{input: [1,0], output: [1]},
      %{input: [1,1], output: [0]}
    ]
  end

  defp examine(network_pid, inputs) do
    val = network_pid |> Network.get |> Network.activate(inputs)
    network = Network.get(network_pid)
    IO.inspect network
    network.hidden_layers
      |> Enum.map(&(Layer.get(&1)))
      |> Enum.flat_map(&(&1.neurons))
      |> Enum.map(&(Neuron.get(&1).output))
      |> IO.inspect
    output_layer = Layer.get(network.output_layer)
    outputs =
      output_layer.neurons
      |> Enum.map(&(Neuron.get(&1).output))
    IO.puts "#{inspect inputs} => #{inspect outputs}"
  end
end
