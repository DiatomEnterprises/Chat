defmodule ChatDemo.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :encrypted_password, :string, null: false
      add :online, :boolean, null: false, default: true

      timestamps
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end
