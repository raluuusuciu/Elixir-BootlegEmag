defmodule Api.ShoppingCartEndpoint do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/:id" do
    case ShoppingCartReverseProxy.get(id) |> IO.inspect() do
      {:ok, response} ->
        conn
        |> put_status(200)
        |> assign(:jsonapi, response.body |> Poison.decode!)
      true ->
        conn
        |> put_status(500)
        |> assign(:jsonapi, %{"message" => "internal server error"})
    end
  end

  post "/" do
    case ShoppingCartReverseProxy.post(conn.params) do
      {:ok, response} ->
        conn
        |> put_status(200)
        |> assign(:jsonapi, response.body |> Poison.decode!)
      true ->
        conn
        |> put_status(500)
        |> assign(:jsonapi, %{"message" => "internal server error"})
    end
  end

  delete "/:id" do
    case ShoppingCartReverseProxy.delete(id) do
      {:ok, response} ->
        conn
        |> put_status(200)
        |> assign(:jsonapi, response.body |> Poison.decode!)
      true ->
        conn
        |> put_status(500)
        |> assign(:jsonapi, %{"message" => "internal server error"})
    end
  end

  patch "/:id" do
    case ShoppingCartReverseProxy.patch(id, conn.params) do
      {:ok, response} ->
        conn
        |> put_status(200)
        |> assign(:jsonapi, response.body |> Poison.decode!)
      true ->
        conn
        |> put_status(500)
        |> assign(:jsonapi, %{"message" => "internal server error"})
    end
  end

end
