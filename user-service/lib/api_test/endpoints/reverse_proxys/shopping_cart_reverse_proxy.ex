defmodule ShoppingCartReverseProxy do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://localhost:4010/shoppingcart"
  plug Tesla.Middleware.JSON

  def get() do
    get("/")
  end

  def post(request_body) do
    post("/", request_body)
  end

  def delete(id) do
    delete("/" <> id)
  end

  def patch(id, request_body) do
    patch("/" <> id, request_body)
  end
end
