defmodule Api.Models.ShoppingCart do
  @db_name Application.get_env(:api_test, :db_db)
  @db_table "shoppingcart"

  use Api.Models.Product

  defstruct [
      :user_id,
      :product_id,
      :quantity
  ]
end
