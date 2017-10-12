defmodule PersonnelServerWeb.DepartmentControllerTest do
  use PersonnelServerWeb.ConnCase

  alias PersonnelServer.Orgstructure
  alias PersonnelServer.Orgstructure.Department

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:department) do
    {:ok, department} = Orgstructure.create_department(@create_attrs)
    department
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all departments", %{conn: conn} do
      conn = get conn, department_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create department" do
    test "renders department when data is valid", %{conn: conn} do
      conn = post conn, department_path(conn, :create), department: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, department_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, department_path(conn, :create), department: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update department" do
    setup [:create_department]

    test "renders department when data is valid", %{conn: conn, department: %Department{id: id} = department} do
      conn = put conn, department_path(conn, :update, department), department: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, department_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, department: department} do
      conn = put conn, department_path(conn, :update, department), department: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete department" do
    setup [:create_department]

    test "deletes chosen department", %{conn: conn, department: department} do
      conn = delete conn, department_path(conn, :delete, department)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, department_path(conn, :show, department)
      end
    end
  end

  defp create_department(_) do
    department = fixture(:department)
    {:ok, department: department}
  end
end
