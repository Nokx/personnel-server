defmodule PersonnelServerWeb.SessionController do
  use PersonnelServerWeb, :controller
  alias PersonnelServer.Accounts
  require Logger

  plug :scrub_params, "session" when action in [:create]

  action_fallback PersonnelServerWeb.FallbackController

  def create(conn, %{"session" => session_params}) do
    with {:ok, user} <- Accounts.authenticate_by_email_password(session_params),
         {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)
    do
      conn
      |> put_status(:created)
      |> render("show.json", jwt: jwt, user: user)
    end
  end

  def delete(conn, _) do
    {:ok, claims} = Guardian.Plug.claims(conn)

    conn
    |> Guardian.Plug.current_token
    |> Guardian.revoke!(claims)
    
    send_resp(conn, :no_content, "")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(PersonnelServerWeb.SessionView, "forbidden.json", error: "Not Authenticated")
  end

end
