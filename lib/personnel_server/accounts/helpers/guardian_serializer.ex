defmodule PersonnelServer.Accounts.GuardianSerializer do
    @behaviour Guardian.Serializer
  
    alias PersonnelServer.Repo
    alias PersonnelServer.Accounts.User
  
    def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }
    def for_token(_), do: { :error, "Unknown resource type" }
  
    def from_token("User:" <> id) do
        user = 
            User
            |> Repo.get!(String.to_integer(id))
            |> Repo.preload(:credential)
       
        { :ok, user }
    end     
    def from_token(_), do: { :error, "Unknown resource type" }
end