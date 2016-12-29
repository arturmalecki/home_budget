defmodule HomeBudget.Router do
  use HomeBudget.Web, :router

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

  pipeline :browser_auth do  
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end  

  scope "/", HomeBudget do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    get "/signup", RegistrationController, :new
    post "/signup", RegistrationController, :create

    resources "/passwords", PasswordController, only: [:new, :create, :edit, :update]

    get "/dashboard", DashboardController, :show

    resources "/projects", ProjectController do
      resources "/accounts", AccountController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomeBudget do
  #   pipe_through :api
  # end
end
