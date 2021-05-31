defmodule Api.Models.User do
    @db_name Application.get_env(:api_test, :db_db)
    @db_table "users"

    use Api.DB.UserRepository

    defstruct [
        :id,
        :name,
        :password
    ]
end
