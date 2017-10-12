defmodule PersonnelServerWeb.PositionView do
  use PersonnelServerWeb, :view
  alias PersonnelServerWeb.PositionView

  def render("index.json", %{positions: positions}) do
    %{data: render_many(positions, PositionView, "position.json")}
  end

  def render("show.json", %{position: position}) do
    %{data: render_one(position, PositionView, "position.json")}
  end

  def render("position.json", %{position: position}) do
    %{
      id: position.id,
      title: position.name,
      name: position.name,
      parent_path: position.parent_path,
      path: position.path,
      parent_id: position.parent_id,
      is_department_head: position.is_department_head,
      department_id: position.department_id
     }
  end

  def render("error.json", :head_position_directly_delete) do
    %{error: %{
        message: "Должность руководителя подразделения можно удалить только через удаление подразделения."
      }
    }
  end

end
