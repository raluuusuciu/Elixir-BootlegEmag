defmodule Api.Router do
  use Plug.Router

  alias Api.Views.ProductView
  alias Api.Models.Product
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

  post "product/", private: %{view: ProductView} do
    {name, category, price, image, id} = {
      Map.get(conn.params, "name", nil),
      Map.get(conn.params, "category", nil),
      Map.get(conn.params, "price", nil),
      Map.get(conn.params, "image", nil),
      Map.get(conn.params, "id", nil)
    }

    cond do
      is_nil(name) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{error: "name must be present!"})

      is_nil(category) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{error: "category must be present!"})

      is_nil(price) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{error: "price must be present!"})

      is_nil(id) ->
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{error: "id must be present!"})

      true ->
      case %Product{name: name, category: category, price: price, image: image, id: id} |> Product.save do
        {:ok, createdProduct} ->
          uri = "#{@api_scheme}://#{@api_host}:#{@api_port}#{conn.request_path}/"
          #not optimal

          conn
          |> put_resp_header("location", "#{uri}#{id}")
          |> put_status(201)
          |> assign(:jsonapi, createdProduct)
        :error ->
          conn
           |> put_status(500)
           |> assign(:jsonapi, %{"error" => "An unexpected error happened"})
      end
    end
  end

  delete "product/:id" do
    case Product.delete(id) do
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

  patch "product/:id", private: %{view: ProductView} do
    {parsedId, ""} = Integer.parse(id)

    {name, category, price, image, id} = {
      Map.get(conn.params, "name", nil),
      Map.get(conn.params, "category", nil),
      Map.get(conn.params, "price", nil),
      Map.get(conn.params, "image", nil),
      Map.get(conn.params, "id", nil)
    }

    Product.delete(parsedId)

    case %Product{name: name, category: category, price: price, image: image, id: id} |> Product.save do
      {:ok, createdProduct} ->
        conn
        |> put_status(200)
        |> assign(:jsonapi, createdProduct)
      :error ->
        conn
         |> put_status(500)
         |> assign(:jsonapi, %{"error" => "An unexpected error happened"})
    end
  end

  get "product/", private: %{view: ProductView}  do
    params = Map.get(conn.params, "filter", %{})

    {_, products} =  Product.find(params)

    conn
    |> put_status(200)
    |> assign(:jsonapi, products)
  end

  match _ do
    conn
    |> put_status(404)
    |> assign(:jsonapi, %{"message" => "not found"})
  end
end
