defmodule PersonnelServer.Accounts do
    @moduledoc """
    The Accounts context.
    """
  
    import Ecto.Query, warn: false
    alias PersonnelServer.Repo
    alias PersonnelServer.Accounts.{User, Credential, Session}
    require Logger

    def list_users do
        User
        |> Repo.all()
        |> Repo.preload(:credential)
    end

    def get_user!(id) do
        User
        |> Repo.get!(id)
        |> Repo.preload(:credential)
    end 

    def create_user(attrs \\ %{}) do
        %User{}
        |> User.changeset(attrs)
        |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
        |> Repo.insert()
    end

    def update_user(%User{} = user, attrs) do
        user
        |> User.changeset(attrs)
        |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
        |> Repo.update()
    end

    def delete_user(%User{} = user) do
        Repo.delete(user)
    end

    def change_user(%User{} = user) do
        User.changeset(user, %{})
    end    

    @doc """
    Returns the list of credentials.

    ## Examples

        iex> list_credentials()
        [%Credential{}, ...]

    """
    def list_credentials do
        Repo.all(Credential)
    end

    @doc """
    Gets a single credential.

    Raises `Ecto.NoResultsError` if the Credential does not exist.

    ## Examples

        iex> get_credential!(123)
        %Credential{}

        iex> get_credential!(456)
        ** (Ecto.NoResultsError)

    """
    def get_credential!(id), do: Repo.get!(Credential, id)

    @doc """
    Creates a credential.

    ## Examples

        iex> create_credential(%{field: value})
        {:ok, %Credential{}}

        iex> create_credential(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_credential(attrs \\ %{}) do
        %Credential{}
        |> Credential.changeset(attrs)
        |> Repo.insert()
    end

    @doc """
    Updates a credential.

    ## Examples

        iex> update_credential(credential, %{field: new_value})
        {:ok, %Credential{}}

        iex> update_credential(credential, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def update_credential(%Credential{} = credential, attrs) do
        credential
        |> Credential.changeset(attrs)
        |> Repo.update()
    end

    @doc """
    Deletes a Credential.

    ## Examples

        iex> delete_credential(credential)
        {:ok, %Credential{}}

        iex> delete_credential(credential)
        {:error, %Ecto.Changeset{}}

    """
    def delete_credential(%Credential{} = credential) do
        Repo.delete(credential)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking credential changes.

    ## Examples

        iex> change_credential(credential)
        %Ecto.Changeset{source: %Credential{}}

    """
    def change_credential(%Credential{} = credential) do
        Credential.changeset(credential, %{})
    end

    def authenticate_by_email_password(%{"email" => email, "password" => password}) do
       Session.authenticate_by_email_password(%{"email" => email, "password" => password})
    end
end
