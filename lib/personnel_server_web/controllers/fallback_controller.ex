defmodule PersonnelServerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PersonnelServerWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(PersonnelServerWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(PersonnelServerWeb.ErrorView, :"404")
  end

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(PersonnelServerWeb.SessionView, "error.json")
  end

  def call(conn, {:error, :head_position_directly_delete}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(PersonnelServerWeb.PositonView, "error.json")
  end
end
