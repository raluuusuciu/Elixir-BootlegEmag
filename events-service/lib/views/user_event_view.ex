defmodule Api.Views.UserEventView do
  use JSONAPI.View

  def fields, do: [:user_id, :action_type]
  def type, do: "user_action_event"
  def relationships, do: []
end
