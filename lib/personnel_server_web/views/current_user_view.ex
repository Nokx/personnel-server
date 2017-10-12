defmodule PersonnelServerWeb.CurrentUserView do
  use PersonnelServerWeb, :view
  alias PersonnelServerWeb.UserView

  def render("show.json", %{user: user}) do
    %{
      data: render(UserView, "user.json", user: user)
    }
  end

  def render("error.json", _) do
  end
end
