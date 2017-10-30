defmodule SirAlexWeb.Router do
  use SirAlexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SirAlexWeb do
    pipe_through :browser # Use the default browser stack

    resources "/users", UserController, only: [:new, :show]
    get "/", PageController, :index
  end

  scope "/auth", SirAlexWeb do
    pipe_through :browser

    get "/login", AuthController, :login
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
