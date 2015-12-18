defmodule ChatDemo.UserView do
  use ChatDemo.Web, :view
  alias ChatDemo.User

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username, online: user.online}
  end
end
