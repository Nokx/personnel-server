defmodule PersonnelServerWeb.CurrentUserController do
  use PersonnelServerWeb, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: PersonnelServerWeb.SessionController
  action_fallback PersonnelServerWeb.FallbackController
  
  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user)
  end
end
