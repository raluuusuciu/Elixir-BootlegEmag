defmodule Api.Models.Discount do
  @db_name Application.get_env(:api_test, :db_db)
  @db_table "events"

  use Api.Models.Discount

  defstruct [
      :id,
      :user_id,
      :discount
  ]
end
