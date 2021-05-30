defmodule Api.Views.ProductEventView do
  use JSONAPI.View

  def fields, do: [:user_id, :product_id, :type]
  def type, do: "product_action_event"
  def relationships, do: []
end
