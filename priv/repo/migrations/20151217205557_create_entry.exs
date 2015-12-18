defmodule ChatDemo.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :message, :string
      add :user_id, references(:users)
      add :room_id, references(:rooms)

      timestamps
    end
    create index(:entries, [:user_id])
    create index(:entries, [:room_id])

  end
end
