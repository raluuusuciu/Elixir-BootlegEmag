defmodule Api.Models.ShoppingCart do
  @db_name Application.get_env(:api_test, :db_db)
  @db_table "shoppingcart"

  use Api.DB.ShoppingCartRepository

  defstruct [
      :user_id,
      :items
  ]
end
