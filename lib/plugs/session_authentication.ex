defmodule ChatDemo.SessionAuthentication do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    if user = user_id && repo.get(ChatDemo.User, user_id) do
      put_current_user(conn, user)
    else
      assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end


  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def login_by_email_and_password(conn, email, given_password, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(ChatDemo.User, email: email)

    cond do
      user && checkpw(given_password, user.encrypted_password) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        {:error, :not_found, conn}
    end
  end

  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user)
    conn
    |> assign(:user_token, token)
    |> assign(:current_user, user)
  end

  def authenticate(conn, _) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: ChatDemo.Router.Helpers.session_path(conn, :new))
      |> halt()
    end
  end
end
