defmodule Api.Views.ProductView do
  use JSONAPI.View

  def fields, do: [:name, :category, :price, :image]
  def type, do: "product"
  def relationships, do: []
end
