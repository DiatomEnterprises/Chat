defmodule ChannelServices.RoomServiceTest do
  use ChatDemo.ModelCase
  alias ChannelServices.RoomService
  alias ChatDemo.User
  alias ChatDemo.Room

  @valid_user_attrs1 %{email: "dainis186@gmail.com", username: "DainisL186", password: "dainis_dainis"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    room_changeset1 = Room.changeset(%Room{}, %{name: "cool name"})
    room_changeset2 = Room.changeset(%Room{}, %{name: "cool name2"})
    {:ok, room1} = Repo.insert(room_changeset1)
    {:ok, room2} = Repo.insert(room_changeset2)

    user_changeset1 = User.registration_changeset(%User{}, @valid_user_attrs1)

    {:ok, user1} = Repo.insert(user_changeset1)

    RoomService.join_room(user1, to_string(room1.id))
    RoomService.join_room(user1, to_string(room2.id))

    result = RoomService.users(to_string(room1.id))
    assert(length(result.users) == 1)
  end
end
