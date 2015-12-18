defmodule ChatDemo.EntryView do
  use ChatDemo.Web, :view

  def render("entries.json", %{entry: entry}) do
    %{
      id: entry.id,
      message: entry.message,
      at: entry.inserted_at,
      user: render_one(entry.user, ChatDemo.UserView, "user.json")
    }
  end
end
