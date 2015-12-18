defmodule ChatDemo.Router do
  use ChatDemo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ChatDemo.SessionAuthentication, repo: ChatDemo.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatDemo do
    pipe_through :browser # Use the default browser stack

    get "/", SessionController, :new
    resources "/session", SessionController, only: [:new, :create, :delete]
    resources "/users", UserController
  end

  scope "/dashboard", ChatDemo do
    pipe_through [:browser, :authenticate] # Use the default browser stack
    resources "/", Dashboard.RoomController, only: [:index]
    resources "/rooms", Dashboard.RoomController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatDemo do
  #   pipe_through :api
  # end
end
