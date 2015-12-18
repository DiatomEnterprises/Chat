defmodule ChatDemo.User do
  use ChatDemo.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :online, :boolean, default: true
    field :encrypted_password, :string
    field :password, :string, virtual: true
    has_many :entries, ChatDemo.Entry
    has_many :user_rooms, ChatDemo.UserRooms
    has_many :rooms, through: [:user_rooms, :user]
    timestamps
  end

  @required_fields ~w(username email)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """

  def update_online_status(model, params) do
    model
    |> cast(params, [], ["online"])
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:username, min: 5, max: 50)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_password_hash
  end

  defp put_password_hash(base_changeset) do
    case base_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(base_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        base_changeset
    end
  end
end
