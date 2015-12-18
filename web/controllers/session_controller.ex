defmodule ChatDemo.SessionController do
  use ChatDemo.Web, :controller
  alias ChatDemo.Repo
  alias ChatDemo.SessionAuthentication
  plug :if_current_user when action in [:new, :create]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case SessionAuthentication.login_by_email_and_password(conn, email, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> redirect(to: room_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> SessionAuthentication.logout()
    |> put_flash(:info, "You have been logged out")
    |> redirect(to: session_path(conn, :new))
  end

  def if_current_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
      |> redirect(to: room_path(conn, :index))
    else
      conn
    end
  end
end
