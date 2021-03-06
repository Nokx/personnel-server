defmodule PersonnelServer.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias PersonnelServer.Repo

  alias PersonnelServer.Chat.Room
  alias PersonnelServer.Chat.UserRoom
  alias PersonnelServer.Chat.Message

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{source: %Room{}}

  """
  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  def create_user_room(attrs \\ %{}) do
    %UserRoom{}
    |> UserRoom.changeset(attrs)
    |> Repo.insert()
  end

  def list_user_rooms(user) do
    user 
    |> Ecto.assoc(:rooms)
    |> Repo.all()
  end

  def room_messages_page(room_id) do
    Message
    |> where([m], m.room_id == ^room_id)
    |> order_by([desc: :inserted_at, desc: :id])
    |> preload([user: [:credential]])
    |> Repo.paginate()
  end

  def load_user_for_message(message) do
    Repo.preload(message, [user: [:credential]])
  end

  def create_message(room, user, params) do
    room
    |> Ecto.build_assoc(:messages, user_id: user.id)
    |> Message.changeset(params)
    |> Repo.insert()
  end

end
