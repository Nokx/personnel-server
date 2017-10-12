defmodule PersonnelServerWeb.SessionView do
  use PersonnelServerWeb, :view
  alias PersonnelServerWeb.UserView
  require Logger

  def render("show.json", %{jwt: jwt, user: user}) do
    %{
      data: %{
        jwt: jwt,
        user: render(UserView, "user.json", user: user)
      }
    }
  end

  def render("error.json", _) do
    %{error: %{
        message: "Неверный email или пароль"
      }
    }
  end

  def render("forbidden.json", %{error: error}) do
    %{error: %{
        message: error
      }
    }
  end
end
