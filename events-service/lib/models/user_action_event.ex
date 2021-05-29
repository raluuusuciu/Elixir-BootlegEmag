defmodule Api.Models.UserEvent do
  @db_name Application.get_env(:api_test, :db_db)
  @db_table "events"

  use Api.Models.UserEvent

  defstruct [
      :id,
      :user_id,
      :action_type
  ]
end
