defmodule PersonnelServer.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias PersonnelServer.Accounts.{Credential, User}

  @derive {Poison.Encoder, only: [:id, :email]}

  schema "credentials" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Credential{} = credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password, message: "Пароли не совпадают")
    |> unique_constraint(:email, message: "Email уже занят")
    |> generate_encrypted_password
  end

  defp generate_encrypted_password(current_changeset) do
      case current_changeset do
        %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
          put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
        _ ->
          current_changeset
      end
   end
end
