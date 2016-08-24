defmodule Absinthe.Phase.Document.Arguments.Defaults do
  @moduledoc """
  Populate all arguments in the document with their provided values:

  - If a literal value is provided for an argument, set the `Argument.t`'s
    `normalized_value` field to that value.
  - If a variable is provided for an argument, set the `Argument.t`'s
    `normalized_value` to the reconciled value for the variable
    (Note: this requires the `Phase.Document.Variables` phase as a
    prerequisite).

  Note that no validation occurs in this phase.
  """

  use Absinthe.Phase
  alias Absinthe.Blueprint

  @spec run(Blueprint.t) :: {:ok, Blueprint.t}
  def run(input) do
    node = Blueprint.prewalk(input, &populate_node/1)
    {:ok, node}
  end

  defp populate_node(%{schema_node: nil} = node), do: node
  defp populate_node(%{arguments: arguments, schema_node: schema_node} = node) do
    %{node | arguments: fill_defaults(arguments, schema_node.args)}
  end
  defp populate_node(node), do: node

  defp fill_defaults(arguments, schema_args) do
    arguments
    |> Enum.filter(&(&1.schema_node))
    |> Enum.reduce(schema_args, &Map.delete(&2, &1.schema_node.__reference__.identifier))
    |> Enum.reduce(arguments, fn
      {_, %{default_value: nil}}, arguments ->
        arguments
      {_, missing_arg}, arguments ->
        [build_arg(missing_arg) | arguments]
    end)
  end

  defp build_arg(schema_node_arg) do
    default = schema_node_arg.default_value
    %Blueprint.Input.Argument{
      name: schema_node_arg.name,
      literal_value: default,
      data_value: default,
      schema_node: schema_node_arg
    }
  end

end
