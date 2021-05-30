defmodule EventsReverseProxy do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://localhost:4010/events"
  plug Tesla.Middleware.JSON

  def get() do
    get("/")
  end

end
