defmodule PersonnelServer.Chat.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset
  alias PersonnelServer.Chat.UserRoom
  alias PersonnelServer.Accounts.User
  alias PersonnelServer.Chat.Room


  schema "user_rooms" do
    belongs_to :user, User
    belongs_to :room, Room

    timestamps()
  end

  @doc false
  def changeset(%UserRoom{} = user_room, attrs) do
    user_room
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> unique_constraint(:user_id_room_id)
  end
end
