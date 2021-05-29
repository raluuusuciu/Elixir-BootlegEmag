use Mix.Config

config :api_test,
  db_host: "localhost",
  db_port: 27017,
  db_db: "database ",
  db_tables: [
    "shoppingcart"
  ],

api_host: "localhost",
api_port: 4000,
api_scheme: "http"
