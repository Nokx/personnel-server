defmodule PersonnelServer.Accounts.Session do
    import Ecto.Query, warn: false
    alias PersonnelServer.Repo
    alias PersonnelServer.Accounts.User
    require Logger
  
    def authenticate_by_email_password(%{"email" => email, "password" => password}) do
      #user = Repo.get_by(User, email: String.downcase(email))
      query = 
        from u in User,
          inner_join: c in assoc(u, :credential),
          where: c.email == ^String.downcase(email),
          preload: [:credential]
      
      user = Repo.one(query);    

      case check_password(user, password) do
        true -> {:ok, user}
        _ -> {:error, :invalid_credentials}
      end
    end
  
    defp check_password(user, password) do
      case user do
        nil -> Comeonin.Bcrypt.dummy_checkpw()
        _ -> Comeonin.Bcrypt.checkpw(password, user.credential.encrypted_password)
      end
    end
end