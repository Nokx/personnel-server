defmodule PersonnelServerWeb.MessageView do
    use PersonnelServerWeb, :view
  
    def render("message.json", %{message: message}) do
        %{
          id: message.id,
          inserted_at: message.inserted_at,
          text: message.text,
          user: %{
            email: message.user.credential.email,
            first_name: message.user.first_name,
            last_name: message.user.last_name
          }
        }
    end
  end
  