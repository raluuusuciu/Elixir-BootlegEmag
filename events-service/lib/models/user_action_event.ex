defmodule Api.Models.UserEvent do
  @db_name Application.get_env(:api_test, :db_db)
  @db_table "events"

  use Api.DB.EventsRepository

  defstruct [
      :id,
      :user_id,
      :type
  ]
end
