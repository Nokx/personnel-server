defmodule PersonnelServerWeb.RoomController do
  use PersonnelServerWeb, :controller

  alias PersonnelServer.Chat
  alias PersonnelServer.Chat.Room
  alias PersonnelServer.Chat.UserRoom

  plug Guardian.Plug.EnsureAuthenticated, handler: PersonnelServerWeb.SessionController
  action_fallback PersonnelServerWeb.FallbackController

  def index(conn, _params) do
    rooms = Chat.list_rooms()
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, %{"room" => room_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    with {:ok, %Room{} = room} <- Chat.create_room(room_params),
         {:ok, %UserRoom{} = _user_room} <- Chat.create_user_room(%{user_id: current_user.id, room_id: room.id}) 
    do
      conn
      |> put_status(:created)
      |> render("show.json", room: room)
    end
  end

  def join(conn, %{"id" => room_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    room = Chat.get_room!(room_id);

    with {:ok, %UserRoom{} = _user_room} <- Chat.create_user_room(%{user_id: current_user.id, room_id: room.id}) do
      conn
      |> put_status(:created)
      |> render("show.json", room: room)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   room = Chat.get_room!(id)
  #   render(conn, "show.json", room: room)
  # end

  # def update(conn, %{"id" => id, "room" => room_params}) do
  #   room = Chat.get_room!(id)

  #   with {:ok, %Room{} = room} <- Chat.update_room(room, room_params) do
  #     render(conn, "show.json", room: room)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   room = Chat.get_room!(id)
  #   with {:ok, %Room{}} <- Chat.delete_room(room) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
