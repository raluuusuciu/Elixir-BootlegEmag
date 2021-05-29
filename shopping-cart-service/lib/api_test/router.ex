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

  post "shoppingcart/", private: %{view: ShoppingCartView} do
    {user_id, product_id, quantity} = {
      Map.get(conn.params, "user_id", nil),
      Map.get(conn.params, "product_id", nil),
      Map.get(conn.params, "quantity", nil)
    }

    cond do
      is_nil(user_id) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{error: "user id must be present!"})

      is_nil(product_id) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{error: "product id must be present!"})

      is_nil(quantity) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{error: "quantity must be present!"})

      true ->
      case %ShoppingCart{user_id: user_id, product_id: product_id, quantity: quantity} |> ShoppingCart.save do
        {:ok, createdEntry} ->
          uri = "#{@api_scheme}://#{@api_host}:#{@api_port}#{conn.request_path}/"
          #not optimal

          conn
          |> put_resp_header("location", "#{uri}#{id}")
          |> put_status(201)
          |> assign(:jsonapi, createdEntry)
        :error ->
          conn
           |> put_status(500)
           |> assign(:jsonapi, %{"error" => "An unexpected error happened"})
      end
    end
  end

  delete "shoppingcart/:id" do
    {parsedId, ""} = Integer.parse(id)

    case ShoppingCart.delete(parsedId) do
      :error ->
         conn
         |> put_status(404)
         |> assign(:jsonapi, %{"error" => "product not found"})
      :ok ->
        conn
        |> put_status(200)
        |> assign(:jsonapi, %{message: "#{id} was deleted"})
    end

  end

  patch "shoppingcart/:id", private: %{view: ShoppingCartView} do
    {parsedId, ""} = Integer.parse(id)
    {user_id, product_id, quantity} = {
      Map.get(conn.params, "user_id", nil),
      Map.get(conn.params, "product_id", nil),
      Map.get(conn.params, "quantity", nil)
    }

    ShoppingCart.delete(parsedId)

    case %ShoppingCart{user_id: user_id, product_id: product_id, quantity: quantity} |> ShoppingCart.save do
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

  get "shoppingcart/", private: %{view: ShoppingCartView}  do
    params = Map.get(conn.params, "filter", %{})

    {_, shoppingcart} =  ShoppingCart.find(params)

    conn
    |> put_status(200)
    |> assign(:jsonapi, shoppingcart)
  end

 forward("/bands", to: Api.Endpoint)

  match _ do
    conn
    |> put_status(404)
    |> assign(:jsonapi, %{"message" => "not found"})
  end
end
