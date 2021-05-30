defmodule Api.ProductEndpoint do
  use Plug.Router

  plug :match
  plug :dispatch


  get "/" do
    case ProductReverseProxy.get() do
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
    case ProductReverseProxy.post(conn.params) do
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
    case ProductReverseProxy.delete(id) do
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
    case ProductReverseProxy.patch(id, conn.params) do
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
