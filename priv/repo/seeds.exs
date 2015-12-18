# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ChatDemo.Repo.insert!(%ChatDemo.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias ChatDemo.User
alias ChatDemo.Repo
root_uesr = %{email: "dainis186@gmail.com", username: "DainisL", password: "dainis18"}
changeset = User.registration_changeset(%User{}, root_uesr)
changeset.valid?
Repo.insert(changeset)
