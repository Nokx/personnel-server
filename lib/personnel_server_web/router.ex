defmodule PersonnelServerWeb.Router do
  use PersonnelServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", PersonnelServerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", PersonnelServerWeb do
    pipe_through :api

    post "/registrations", RegistrationController, :create
    get "/current_user", CurrentUserController, :show

    resources "/sessions", SessionController, only: [:create, :delete], singleton: true

    resources "/departments", DepartmentController, except: [:new, :edit]
    get "/tree/department/subtree/:path_from/:depth", DepartmentController, :subtree
    delete "/tree/departments/:path", DepartmentController, :delete_with_children

    resources "/positions", PositionController, except: [:new, :edit]
    get "/tree/position/subtree/:path_from/:depth", PositionController, :subtree
    delete "/tree/positions/:path", PositionController, :delete_with_childs

    resources "/users", UserController, except: [:new, :edit]
    get "/users/:id/rooms", UserController, :rooms
    
    resources "/rooms", RoomController, only: [:index, :create]
    post "/rooms/:id/join", RoomController, :join
  end
end
