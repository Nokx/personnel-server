defmodule PersonnelServerWeb.PositionController do
    use PersonnelServerWeb, :controller
    require Logger

    alias PersonnelServer.Orgstructure
    alias PersonnelServer.Orgstructure.Position

    plug Guardian.Plug.EnsureAuthenticated, handler: PersonnelServerWeb.SessionController
    action_fallback PersonnelServerWeb.FallbackController

    def index(conn, _params) do
        positions = Orgstructure.list_positions()
        render(conn, "index.json", positions: positions)
    end

    def create(conn, %{"position" => position_params}) do
      with {:ok, %Position{} = position} <- Orgstructure.create_position(position_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", position_path(conn, :show, position))
        |> render("show.json", position: position)
      end
    end

    def show(conn, %{"id" => id}) do
      position = Orgstructure.get_position!(id)
      render(conn, "show.json", position: position)
    end

    def update(conn, %{"id" => id, "position" => position_params}) do
      position = Orgstructure.get_position!(id)

      with {:ok,%Position{} = position} <- Orgstructure.update_position(position, position_params) do
        render(conn, "show.json", position: position)
      end
    end

    def delete(conn, %{"id" => id}) do
      position = Orgstructure.get_position!(id)
      with {:ok, _} <- Orgstructure.delete_position(position) do
        send_resp(conn, :no_content, "")
      end
    end

    def subtree(conn, %{"path_from" => path_from, "depth" => depth}) do
      positions = Orgstructure.get_position_subtree!(path_from, depth)
      render(conn, "index.json", positions: positions)
    end

    def delete_with_childs(conn, %{"path" => path}) do
      with {:ok, _} <- Orgstructure.delete_position_with_childs!(path) do
        send_resp(conn, :no_content, "")
      end
    end
  end
