use Mix.Config

config :api_test,
api_host: "localhost",
api_port: 4000,
api_scheme: "http",
app_secret_key: "secret",
jwt_validity: 3600,

routing_keys: %{
    # User Events
    "user_login" => "api.login.auth-login.events",
    "user_register" => "api.login.auth-register.events",
    "user_logout" => "api.login.auth-logout.events"
},
event_url: "guest:guest@localhost", #username:passwd (here default)
event_exchange: "auth_api",
event_queue: "events_service"
