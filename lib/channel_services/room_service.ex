defmodule ChannelServices.RoomService do
  alias ChatDemo.EntryView
  alias ChatDemo.UserView

  alias ChatDemo.Repo
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def join_room(user, room_id) do
    room_id =  String.to_integer(room_id)

    query = from(ur in ChatDemo.UserRooms,
      where: ur.user_id == ^user.id and ur.room_id == ^room_id,
      select: count(ur.id))

    case Repo.all(query) do
      [0] ->
        changeset = build_assoc(user, :user_rooms, room_id: room_id)
        Repo.insert(changeset);
      [_] ->
    end

    channel_action(user, :join)
  end

  def history(room_id) do
    room_id = String.to_integer(room_id)

    room = Repo.get!(ChatDemo.Room, room_id)
    entries = Repo.all(
      from e in assoc(room, :entries),
        order_by: [desc: e.inserted_at],
        limit: 200,
      preload: [:user]
    )

    %{entries: Phoenix.View.render_many(entries, EntryView, "entries.json")}
  end

  def users(room_id) do
    room_id = String.to_integer(room_id)
    room = Repo.get!(ChatDemo.Room, room_id)
    users = Repo.all assoc(room, :users)
    %{ users: Phoenix.View.render_many(users, UserView, "user.json")}
  end

  def channel_action(user, action) do
    user = Repo.get!(ChatDemo.User, user.id)
    changeset = case action do
      :join ->
        ChatDemo.User.update_online_status(user, %{online: true})
      :closed ->
        ChatDemo.User.update_online_status(user, %{online: false})
    end

    Repo.update!(changeset)
  end

  def create_entry(user, room_id, params) do
    room_id =  String.to_integer(room_id)
    changeset = build_assoc(user, :entries, room_id: room_id, message: params["body"])

    case Repo.insert(changeset) do
      {:ok, entry} ->
        {:ok, entry}
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
