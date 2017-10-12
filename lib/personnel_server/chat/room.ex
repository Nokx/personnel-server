defmodule PersonnelServer.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias PersonnelServer.Accounts.User
  alias PersonnelServer.Chat.Room
  alias PersonnelServer.Chat.Message


  schema "rooms" do
    field :name, :string
    field :topic, :string
    many_to_many :users, User, join_through: "user_rooms"
    has_many :messages, Message

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name, :topic])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
