defmodule Api.Router do
  use Plug.Router

  alias Api.Views.ShoppingCartView
  alias Api.Models.ShoppingCart
  alias Api.Plugs.JsonTestPlug

  @routing_keys Application.get_env(:api_test, :routing_keys)

  plug(:match)
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )
  plug(:dispatch)
  plug :encode_response

  defp encode_response(conn, _) do
    conn
    |> send_resp(conn.status, conn.assigns |> Map.get(:jsonapi, %{}) |> Poison.encode!)
  end

  delete "shoppingcart/:id" do
    case ShoppingCart.delete(id) do
      :error ->
         conn
         |> put_status(404)
         |> assign(:jsonapi, %{"error" => "shopping cart not found"})
      :ok ->
        conn
        |> put_status(200)
        |> assign(:jsonapi, %{message: "#{id} was deleted"})
    end
  end

  post "shoppingcart/", private: %{view: ShoppingCartView} do
    {user_id, items} = {
      Map.get(conn.params, "user_id", nil),
      Map.get(conn.params, "items", nil)
    }

    ShoppingCart.delete(user_id)

    case %ShoppingCart{user_id: user_id, items: items} |> ShoppingCart.save do
      {:ok, createdEntry} ->
        conn
        |> put_status(200)
        |> assign(:jsonapi, createdEntry)
      :error ->
        conn
         |> put_status(500)
         |> assign(:jsonapi, %{"error" => "An unexpected error happened"})
    end
  end

  get "shoppingcart", private: %{view: ShoppingCartView}  do
    params = Map.get(conn.params, "filter", %{})
    {_, shoppingcart} =  ShoppingCart.find(params)

    conn
    |> put_status(200)
    |> assign(:jsonapi, shoppingcart)
  end

  get "shoppingcart/:username", private: %{view: ShoppingCartView} do
    {_, shoppingcart} = ShoppingCart.get(username)

    conn
    |> put_status(200)
    |> assign(:jsonapi, shoppingcart)
  end

  match _ do
    conn
    |> put_status(404)
    |> assign(:jsonapi, %{"message" => "not found"})
  end
end
