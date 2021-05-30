defmodule ApiTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ets.new(:bands, [:bag, :public, :named_table])
    :ets.new(:users, [:bag, :public, :named_table])

    children = [
      # Starts a worker by calling: ApiTest.Worker.start_link(arg)
      # {ApiTest.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: Api.Router, options: [port: api_port]},
      {Mongo, [name: :mongo, url: "mongodb://root-user:password@localhost:27017/users"]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ApiTest.Supervisor]
    Supervisor.start_link(children, opts)

    Api.Service.Publisher.start_link
  end

  defp api_port, do: Application.get_env(:api_test, :api_port)
end
