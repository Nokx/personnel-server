defmodule PersonnelServerWeb.RegistrationController  do
  use PersonnelServerWeb, :controller
  alias PersonnelServer.Accounts

  plug :scrub_params, "user" when action in [:create]
  action_fallback PersonnelServerWeb.FallbackController
  
  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params),
         {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token) do
           
        conn
        |> put_status(:created)
        |> render(PersonnelServerWeb.SessionView, "show.json", jwt: jwt, user: user)
    end
  end
end
