defmodule Api.Router do
  use Plug.Router

  alias Api.Models.User
  alias Api.Service.Publisher

  @routing_keys Application.get_env(:api_test, :routing_keys)

  plug CORSPlug
  plug(:match)
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )
  plug Api.AuthPlug
  plug(:dispatch)
  plug :encode_response

  defp encode_response(conn, _) do
      conn
      |> send_resp(conn.status, conn.assigns |> Map.get(:jsonapi, %{}) |> Poison.encode!)
  end

  post "/login", private: %{jwt_skip: true} do
   {name, password, id} = {
     Map.get(conn.params, "name", nil),
     Map.get(conn.params, "password", nil),
     Map.get(conn.params, "id", nil)
   }

    cond do
      name == "admin" and password == "admin" ->
        {:ok, service} = Api.Service.Auth.start_link
        token = Api.Service.Auth.issue_token(service, %{:id => id})

        #publishing login event
      #Publisher.publish(
        #@routing_keys |> Map.get("user_login"),
        #%{:id => id, :name => name})
        # user |> Map.take([:id,:name]))

     conn
         |> put_status(200)
         |> assign(:jsonapi, %{:token => token})
         |> assign(:claims, %{:id => id, :token => token})

      true ->
        case User.get(name) do
            {:ok, user} ->
                cond do user.password == password ->
                    {:ok, service} = Api.Service.Auth.start_link
                    token = Api.Service.Auth.issue_token(service, %{:id => user.id})

                    Publisher.publish(
                        @routing_keys |> Map.get("user_login"),
                        %{:id => user.id, :name => user.name})

                    conn
                    |> put_status(200)
                    |> assign(:jsonapi, %{:token => token})
                    |> assign(:claims, %{:id => id, :token => token})
                true ->
                    conn
                    |> put_status(404)
                    |> assign(:jsonapi, %{"message" => "no access"})
                end
            end

            true ->
                conn
                |> put_status(404)
                |> assign(:jsonapi, %{"message" => "no access"})
            end
 end

 post "/register", private: %{jwt_skip: true} do
  {name, password, id} = {
    Map.get(conn.params, "name", nil),
    Map.get(conn.params, "password", nil),
    Map.get(conn.params, "id", nil)
  }

  cond do
    is_nil(name) ->
      conn
      |> put_status(400)
      |> assign(:jsonapi, %{error: "name must be present!"})


    is_nil(password) ->
      conn
      |> put_status(400)
      |> assign(:jsonapi, %{error: "password must be present!"})

    true ->
      id = UUID.uuid4()
      case %User{name: name, password: password, id: id} |> User.save do
        {:ok, createdUser} ->
          Publisher.publish(
          @routing_keys |> Map.get("user_register"),
          %{:id => createdUser.id, :name => createdUser.name})

          conn
          |> put_status(201)
          |> assign(:jsonapi, createdUser)
          |> assign(:claims, %{:id => id})

          uri = "#{@api_scheme}://#{@api_host}:#{@api_port}#{conn.request_path}/"
          conn
            |> put_resp_header("location", "#{uri}#{id}")
            |> put_status(201)
            |> assign(:jsonapi, createdUser)
        :error ->
          conn
           |> put_status(500)
           |> assign(:jsonapi, %{"error" => "An unexpected error happened"})
      end
    end
  end

  post "/logout" do
    {:ok, service} = Api.Service.Auth.start_link

    case Api.Service.Auth.revoke_token(service, conn.assigns.claims) do
        {:ok, id} ->
        #Publisher.publish(
        #    @routing_keys |> Map.get("user_logout"),
        #    %{:id => conn.assigns.claims.id, :id => id})

        conn
            |> put_status(201)
            |> assign(:jsonapi, %{"id" => id})
        true ->
            conn
            |> put_status(404)
            |> assign(:jsonapi, %{"message" => "not found"})
        end
  end

  forward("/bands", to: Api.Endpoint)
  forward("/product", to: Api.ProductEndpoint)
  forward("/shoppingcart", to: Api.ShoppingCartEndpoint)

  match _ do
    conn
    |> put_status(404)
    |> assign(:jsonapi, %{"message" => "not found"})
  end
end
