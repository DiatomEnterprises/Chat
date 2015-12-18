defmodule ChatDemo.UserRoomsTest do
  use ChatDemo.ModelCase

  alias ChatDemo.UserRooms

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserRooms.changeset(%UserRooms{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserRooms.changeset(%UserRooms{}, @invalid_attrs)
    refute changeset.valid?
  end
end
