defmodule Api.Models.Product do
  @db_name Application.get_env(:api_test, :db_db)
  @db_table "products"

  use Api.Models.Product

  defstruct [
      :id,
      :name,
      :category,
      :price,
      :image
  ]
end
