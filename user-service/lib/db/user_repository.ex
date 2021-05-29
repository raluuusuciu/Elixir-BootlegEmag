defmodule Api.DB.UserRepository do
    def add(user) do
        :ets.insert(:users, {user.name, user})
        user
    end

    def remove(id) do
        :ets.delete(:users, id)
    end

    def get_all() do
        :ets.match(:users, {:"$1", :"$2"})
        |> Enum.map(fn x -> Enum.at(x, 1) end)
    end

    def get_by_id(id) do
        user = :ets.lookup(:users, id)
        |> Enum.map(fn x -> elem(x, 1) end)
        |> List.first

        if is_nil(user) do
            :error
        else
            {:ok, user}
        end
    end
end