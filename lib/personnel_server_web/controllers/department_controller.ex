defmodule PersonnelServerWeb.DepartmentController do
  use PersonnelServerWeb, :controller

  alias PersonnelServer.Orgstructure
  alias PersonnelServer.Orgstructure.Department

  plug Guardian.Plug.EnsureAuthenticated, handler: PersonnelServerWeb.SessionController
  action_fallback PersonnelServerWeb.FallbackController

  def index(conn, _params) do
    departments = Orgstructure.list_departments()
    render(conn, "index.json", departments: departments)
  end

  def create(conn, %{"department" => department_params}) do
    with {:ok, %Department{} = department} <- Orgstructure.create_department(department_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", department_path(conn, :show, department))
      |> render("show.json", department: department)
    end
  end

  def show(conn, %{"id" => id}) do
    department = Orgstructure.get_department!(id)
    render(conn, "show.json", department: department)
  end

  def update(conn, %{"id" => id, "department" => department_params}) do
    department = Orgstructure.get_department!(id)

    with {:ok, %Department{} = department} <- Orgstructure.update_department(department, department_params) do
      render(conn, "show.json", department: department)
    end
  end

  def delete(conn, %{"id" => id}) do
    department = Orgstructure.get_department!(id)
    with {:ok, %Department{}} <- Orgstructure.delete_department(department) do
      send_resp(conn, :no_content, "")
    end
  end

  def subtree(conn, %{"path_from" => path_from, "depth" => depth}) do
    departments = Orgstructure.get_department_subtree!(path_from, depth)
    render(conn, "index.json", departments: departments)
  end

  def delete_with_children(conn, %{"path" => path}) do
    Orgstructure.delete_department_with_children!(path)
    send_resp(conn, :no_content, "")
  end
end
