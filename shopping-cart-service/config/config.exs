use Mix.Config

config :api_test,
  db_host: "localhost",
  db_port: 27017,
  db_db: "shoppingcart",
  db_tables: [
    "shoppingcart"
  ],

api_host: "localhost",
api_port: 4011,
api_scheme: "http",
show_sensitive_data_on_connection_error: true
