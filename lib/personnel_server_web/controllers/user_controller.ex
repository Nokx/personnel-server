defmodule PersonnelServerWeb.UserController do
    use PersonnelServerWeb, :controller
    require Logger

    alias PersonnelServer.Accounts
    alias PersonnelServer.Accounts.User
    alias PersonnelServer.Chat

    plug Guardian.Plug.EnsureAuthenticated, handler: PersonnelServerWeb.SessionController
    action_fallback PersonnelServerWeb.FallbackController

    def index(conn, _params) do
        users = Accounts.list_users()
        render(conn, "index.json", users: users)
    end
    
    def create(conn, %{"user" => user_params}) do
        with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", user_path(conn, :show, user))
          |> render("show.json", user: user)
        end
    end
    
    def show(conn, %{"id" => id}) do
        user = Accounts.get_user!(id)
        render(conn, "show.json", user: user)
    end
    
    def update(conn, %{"id" => id, "user" => user_params}) do
        user = Accounts.get_user!(id)
    
        with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
          render(conn, "show.json", user: user)
        end
    end
    
    def delete(conn, %{"id" => id}) do
        user = Accounts.get_user!(id)
        with {:ok, _} <- Accounts.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
    end

    def rooms(conn, _params) do
        current_user = Guardian.Plug.current_resource(conn)
        rooms = Chat.list_user_rooms(current_user)
        render(conn, PersonnelServerWeb.RoomView, "index.json", rooms: rooms)
    end

end