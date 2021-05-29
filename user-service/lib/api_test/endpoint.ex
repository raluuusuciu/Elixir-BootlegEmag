defmodule Api.Endpoint do
  use Plug.Router

  @skip_token_verification %{jwt_skip: true}

  plug :match
  plug :dispatch

  get "/public" do
    conn
    |> put_status(200)
    |> assign(:jsonapi, %{"message" => "'this' is a public EP"})
  end

  get "/private" do
    conn
    |> put_status(200)
    |> assign(:jsonapi, %{"message" => "'this' is a private EP"})
  end

end
