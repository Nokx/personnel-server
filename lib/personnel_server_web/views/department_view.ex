defmodule PersonnelServerWeb.DepartmentView do
  use PersonnelServerWeb, :view
  alias PersonnelServerWeb.DepartmentView

  def render("index.json", %{departments: departments}) do
    %{data: render_many(departments, DepartmentView, "department.json")}
  end

  def render("show.json", %{department: department}) do
    %{data: render_one(department, DepartmentView, "department.json")}
  end

  def render("department.json", %{department: department}) do
    %{
      id: department.id,
      title: department.name,
      name: department.name,
      parent_path: department.parent_path,
      path: department.path,
      parent_id: department.parent_id
     }
  end
end
