defmodule Api.EventsEndpoint do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    case EventsReverseProxy.get() do
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
