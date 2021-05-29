defmodule Api.Views.ProductEventView do
  use JSONAPI.View

  def fields, do: [:user_id, :product_id, :action_type]
  def type, do: "product_action_event"
  def relationships, do: []
end
