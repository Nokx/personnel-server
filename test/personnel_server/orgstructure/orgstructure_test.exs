defmodule PersonnelServer.OrgstructureTest do
  use PersonnelServer.DataCase

  alias PersonnelServer.Orgstructure

  describe "departments" do
    alias PersonnelServer.Orgstructure.Department

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def department_fixture(attrs \\ %{}) do
      {:ok, department} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orgstructure.create_department()

      department
    end

    test "list_departments/0 returns all departments" do
      department = department_fixture()
      assert Orgstructure.list_departments() == [department]
    end

    test "get_department!/1 returns the department with given id" do
      department = department_fixture()
      assert Orgstructure.get_department!(department.id) == department
    end

    test "create_department/1 with valid data creates a department" do
      assert {:ok, %Department{} = department} = Orgstructure.create_department(@valid_attrs)
      assert department.name == "some name"
    end

    test "create_department/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orgstructure.create_department(@invalid_attrs)
    end

    test "update_department/2 with valid data updates the department" do
      department = department_fixture()
      assert {:ok, department} = Orgstructure.update_department(department, @update_attrs)
      assert %Department{} = department
      assert department.name == "some updated name"
    end

    test "update_department/2 with invalid data returns error changeset" do
      department = department_fixture()
      assert {:error, %Ecto.Changeset{}} = Orgstructure.update_department(department, @invalid_attrs)
      assert department == Orgstructure.get_department!(department.id)
    end

    test "delete_department/1 deletes the department" do
      department = department_fixture()
      assert {:ok, %Department{}} = Orgstructure.delete_department(department)
      assert_raise Ecto.NoResultsError, fn -> Orgstructure.get_department!(department.id) end
    end

    test "change_department/1 returns a department changeset" do
      department = department_fixture()
      assert %Ecto.Changeset{} = Orgstructure.change_department(department)
    end
  end
end
