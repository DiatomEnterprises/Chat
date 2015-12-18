defmodule ChatDemo.Room do
  use ChatDemo.Web, :model

  schema "rooms" do
    field :name, :string
    has_many :entries, ChatDemo.Entry
    has_many :user_rooms, ChatDemo.UserRooms
    has_many :users, through: [:user_rooms, :room]
    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
