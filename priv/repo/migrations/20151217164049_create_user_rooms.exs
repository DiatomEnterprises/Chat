defmodule ChatDemo.Repo.Migrations.CreateUserRooms do
  use Ecto.Migration

  def change do
    create table(:user_rooms) do
      add :room_id, references(:rooms, on_delete: :delete_all), null: false
      add :user_id, references(:users), null: false
      timestamps
    end

    create index(:user_rooms, [:room_id, :user_id])
  end
end
