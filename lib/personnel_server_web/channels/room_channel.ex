defmodule PersonnelServerWeb.RoomChannel do
    use PersonnelServerWeb, :channel
    alias PersonnelServer.Chat
    alias PersonnelServerWeb.RoomView
    alias PersonnelServerWeb.MessageView
  
    def join("rooms:" <> room_id, _params, socket) do
      room = Chat.get_room!(room_id)
  
      page = Chat.room_messages_page(room.id)

      response = %{
        room: RoomView.render("room.json", room: room),
        messages: Phoenix.View.render_many(page.entries, MessageView, "message.json"),
        pagination: PersonnelServer.PaginationHelpers.pagination(page)
      }
  
      {:ok, response, assign(socket, :room, room)}
    end
  
    def handle_in("new_message", params, socket) do
      case Chat.create_message(socket.assigns.room, socket.assigns.current_user, params) do
        {:ok, message} ->
          broadcast_message(socket, message)
          {:reply, :ok, socket}
        {:error, changeset} ->
          {:reply, {:error, Phoenix.View.render(PersonnelServerWeb.ChangesetView, "error.json", changeset: changeset)}, socket} 
      end
    end

    def terminate(_reason, socket) do
      {:ok, socket}
    end

    defp broadcast_message(socket, message) do
      message = Chat.load_user_for_message(message)
      rendered_message = Phoenix.View.render_one(message, MessageView, "message.json")
      broadcast!(socket, "message_created", rendered_message)
    end
end
