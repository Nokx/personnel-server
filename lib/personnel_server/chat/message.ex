defmodule PersonnelServer.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias PersonnelServer.Chat.Message
  alias PersonnelServer.Accounts.User
  alias PersonnelServer.Chat.Room


  schema "messages" do
    field :text, :string
    belongs_to :room, Room
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:text, :user_id, :room_id])
    |> validate_required([:text, :user_id, :room_id])
  end
end
