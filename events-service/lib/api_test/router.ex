defmodule Api.Router do
    use Plug.Router

    alias Api.Views.UserEventView
    alias Api.Views.ProductEventView
    alias Api.Models.UserEvent
    alias Api.Models.ProductEvent
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

    post "events/useraction", private: %{view: UserEventView} do
        {user_id, type, id} = {
            Map.get(conn.params, "user_id", nil),
            Map.get(conn.params, "type", nil),
            Map.get(conn.params, "id", nil)
        }

        cond do
            is_nil(user_id) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{error: "user id must be present!"})

            is_nil(type) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{error: "action type must be present!"})

            is_nil(id) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{error: "id must be present!"})

        true ->
            case %UserEvent{user_id: user_id, type: type, id: id} |> UserEvent.save do
                {:ok, createdUserAction} ->
                    uri = "#{@api_scheme}://#{@api_host}:#{@api_port}#{conn.request_path}/"
                    #not optimal

                    # Publisher.publish(
                    #     @routing_keys |> Map.get("user_action"),
                    #     %{:id => createdUserAction.id, :action_type => createdUserAction.action_type})

                    conn
                    |> put_resp_header("location", "#{uri}#{id}")
                    |> put_status(201)
                    |> assign(:jsonapi, createdUserAction)
                :error ->
                    conn
                    |> put_status(500)
                    |> assign(:jsonapi, %{"error" => "An unexpected error happened"})
            end
        end
    end

    post "events/productaction", private: %{view: ProductEventView} do
        {user_id, product_id, type, id} = {
            Map.get(conn.params, "user_id", nil),
            Map.get(conn.params, "product_id", nil),
            Map.get(conn.params, "type", nil),
            Map.get(conn.params, "id", nil)
        }

        cond do
            is_nil(user_id) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{error: "user id must be present!"})

            is_nil(product_id) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{error: "user id must be present!"})

            is_nil(type) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{error: "action type must be present!"})

            is_nil(id) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{error: "id must be present!"})

        true ->
            case %ProductEvent{user_id: user_id, product_id: product_id, type: type, id: id} |> ProductEvent.save do
                {:ok, createdProductAction} ->
                uri = "#{@api_scheme}://#{@api_host}:#{@api_port}#{conn.request_path}/"
                 #not optimal

                # Publisher.publish(
                #     @routing_keys |> Map.get("product_action"),
                #     %{:id => createdProductAction.id, :action_type => createdProductAction.action_type})

                    conn
                    |> put_resp_header("location", "#{uri}#{id}")
                    |> put_status(201)
                    |> assign(:jsonapi, createdProductAction)
                :error ->
                    conn
                    |> put_status(500)
                    |> assign(:jsonapi, %{"error" => "An unexpected error happened"})
            end
        end
    end

    match _ do
        conn
        |> put_status(404)
        |> assign(:jsonapi, %{"message" => "not found"})
    end
end
