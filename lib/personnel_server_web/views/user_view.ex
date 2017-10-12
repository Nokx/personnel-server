defmodule PersonnelServerWeb.UserView do
    use PersonnelServerWeb, :view
    alias PersonnelServerWeb.UserView
  
    def render("index.json", %{users: users}) do
      %{data: render_many(users, UserView, "user.json")}
    end
  
    def render("show.json", %{user: user}) do
      %{data: render_one(user, UserView, "user.json")}
    end
  
    def render("user.json", %{user: user}) do
      %{
        id: user.id,
        email: user.credential.email,
        first_name: user.first_name,
        last_name: user.last_name
      }
    end
  end