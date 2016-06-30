defmodule Absinthe.Blueprint.IDL.EnumTypeDefinition do

  alias Absinthe.Language

  defstruct name: nil, values: [], errors: [], ast_node: nil
  @type t :: %__MODULE__{} # TODO

  @spec from_ast(Language.EnumTypeDefinition.t, Language.Document.t) :: t
  def from_ast(%Language.EnumTypeDefinition{} = node, _doc) do
    %__MODULE__{
      name: node.name,
      values: node.values,
      ast_node: node
    }
  end

end
