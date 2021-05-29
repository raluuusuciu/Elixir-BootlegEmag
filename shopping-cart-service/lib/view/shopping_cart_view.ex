defmodule Api.Views.ShoppingCartView do
  use JSONAPI.View

  def fields, do: [:user_id, :product_id, :quantity]
  def type, do: "shopping_cart"
  def relationships, do: []
end
