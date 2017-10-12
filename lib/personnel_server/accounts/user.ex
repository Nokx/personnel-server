defmodule PersonnelServer.Accounts.User do
    use Ecto.Schema
    import Ecto.Changeset
    require Logger

    alias PersonnelServer.Accounts.Credential
    alias PersonnelServer.Chat.Room
    alias PersonnelServer.Chat.Message

    schema "users" do
      field :first_name, :string
      field :last_name, :string

      has_one :credential, Credential
      many_to_many :rooms, Room, join_through: "user_rooms"
      has_many :messages, Message

      timestamps()
    end

    def changeset(model, params \\ :empty) do
      model
      |> cast(params, [:first_name, :last_name])
      |> validate_required([:first_name, :last_name])
    end

  end
