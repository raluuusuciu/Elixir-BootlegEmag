use Mix.Config

config :api_test,
  db_host: "localhost",
  db_port: 27017,
  db_db: "database ",
  db_tables: [
    "events"
  ],

api_host: "localhost",
api_port: 4000,
api_scheme: "http"

routing_keys: %{
    # Events
    "user_action" => "api.events.user-action.event",
    "product_action" => "api.events.product-action.event"
},
event_url: "guest:guest@localhost", #username:passwd (here default)
event_exchange: "events_api",
event_queue: "events_service"
