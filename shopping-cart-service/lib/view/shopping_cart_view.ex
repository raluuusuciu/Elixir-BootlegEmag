defmodule Api.Views.ShoppingCartView do
  use JSONAPI.View

  def fields, do: [:user_id, :items]
  def type, do: "shopping_cart"
  def relationships, do: []
end
