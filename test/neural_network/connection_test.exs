defmodule NeuralNetwork.ConnectionTest do
  use ExUnit.Case
  doctest NeuralNetwork.Connection

  test "has default values" do
    connection = %NeuralNetwork.Connection{}
    assert connection.source == %{}
    assert connection.target == %{}
    assert connection.weight == 0.4
  end

  test "has default values using an agent" do
    NeuralNetwork.Connection.start_link(:one)
    connection = NeuralNetwork.Connection.get(:one)
    assert connection.source == %{}
    assert connection.target == %{}
    assert connection.weight == 0.4
  end

  test "create new connection with custom values" do
    NeuralNetwork.Connection.start_link(:one, %{source: %{this: "will be a neuron"}, target: %{this: "will be a neuron"}})
    connection = NeuralNetwork.Connection.get(:one)
    assert connection.source == %{this: "will be a neuron"}
    assert connection.target == %{this: "will be a neuron"}
    assert connection.weight == 0.4
  end

  test "update connection values" do
    NeuralNetwork.Connection.start_link(:one)
    NeuralNetwork.Connection.update(:one, %{source: %NeuralNetwork.Neuron{input: 10}, target: %NeuralNetwork.Neuron{input: 5} })
    connection = NeuralNetwork.Connection.get(:one)
    assert connection.source.input == 10
    assert connection.target.input == 5
  end

  test "create a connection for two neurons" do
    NeuralNetwork.Neuron.start_link(%{name: :neuronA})
    neuronA = NeuralNetwork.Neuron.get(:neuronA)
    NeuralNetwork.Neuron.start_link(%{name: :neuronB})
    neuronB = NeuralNetwork.Neuron.get(:neuronB)

    connection = NeuralNetwork.Connection.connection_for(neuronA, neuronB)

    assert connection.source == neuronA
    assert connection.target == neuronB
  end
end
