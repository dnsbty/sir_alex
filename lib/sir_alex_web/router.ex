defmodule SirAlexWeb.Router do
  use SirAlexWeb, :router
  import SirAlexWeb.Plugs.CurrentUser

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :get_current_user
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SirAlexWeb do
    pipe_through :browser # Use the default browser stack

    resources "/groups/:group_id/members", MemberController
    delete "/groups/:group_id/members", MemberController, :leave
    get "/groups/:group_id/requests", MemberRequestController, :index
    put "/groups/:group_id/requests/:member_id/accept", MemberRequestController, :accept
    put "/groups/:group_id/requests/:member_id/reject", MemberRequestController, :reject
    resources "/groups", GroupController
    resources "/users", UserController, only: [:new, :show]
    get "/", PageController, :index
  end

  scope "/auth", SirAlexWeb do
    pipe_through :browser

    get "/login", AuthController, :login
    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
