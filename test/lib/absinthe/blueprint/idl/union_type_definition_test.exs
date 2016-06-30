defmodule Absinthe.Blueprint.IDL.UnionTypeDefinitionTest do
  use Absinthe.Case, async: true

  alias Absinthe.Blueprint

  @text "A metasyntactic variable"
  @idl """
  type Foo {
    name: String
  }

  type Bar {
    name: String
  }

  union Baz @description(text: "#{@text}") =
    Foo
  | Bar

  """

  describe ".from_ast" do

    it "works, given an IDL 'union' definition" do
      assert %Blueprint.IDL.UnionTypeDefinition{name: "Baz", types: [%Blueprint.NamedType{name: "Foo"}, %Blueprint.NamedType{name: "Bar"}], directives: [%{name: "description"}]} = from_input(@idl)
    end

  end

  defp from_input(text) do
    doc = Absinthe.parse!(text)

    doc
    |> extract_ast_node
    |> Blueprint.IDL.UnionTypeDefinition.from_ast(doc)
  end

  defp extract_ast_node(%Absinthe.Language.Document{definitions: definitions}) do
    definitions |> List.last
  end

end
