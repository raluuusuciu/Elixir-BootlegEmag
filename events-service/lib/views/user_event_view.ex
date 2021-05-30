defmodule Api.Views.UserEventView do
  use JSONAPI.View

  def fields, do: [:user_id, :type]
  def type, do: "user_action_event"
  def relationships, do: []
end
