defmodule PersonnelServer.Orgstructure do
  @moduledoc """
  The Orgstructure context.
  """

  import Ecto.Query, warn: false
  alias PersonnelServer.Repo

  alias PersonnelServer.Orgstructure.Department
  alias PersonnelServer.Orgstructure.Position

  @doc """
  Returns the list of departments.

  ## Examples

      iex> list_departments()
      [%Department{}, ...]

  """
  def list_departments do
    Repo.all(Department)
  end

  @doc """
  Gets a single department.

  Raises `Ecto.NoResultsError` if the Department does not exist.

  ## Examples

      iex> get_department!(123)
      %Department{}

      iex> get_department!(456)
      ** (Ecto.NoResultsError)

  """
  def get_department!(id), do: Repo.get!(Department, id)

  @doc """
  Creates a department.

  ## Examples

      iex> create_department(%{field: value})
      {:ok, %Department{}}

      iex> create_department(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_department(attrs \\ %{}) do
    %Department{}
    |> Department.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a department.

  ## Examples

      iex> update_department(department, %{field: new_value})
      {:ok, %Department{}}

      iex> update_department(department, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_department(%Department{} = department, attrs) do
    department
    |> Department.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Department.

  ## Examples

      iex> delete_department(department)
      {:ok, %Department{}}

      iex> delete_department(department)
      {:error, %Ecto.Changeset{}}

  """
  def delete_department(%Department{} = department) do
    Repo.delete(department)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking department changes.

  ## Examples

      iex> change_department(department)
      %Ecto.Changeset{source: %Department{}}

  """
  def change_department(%Department{} = department) do
    Department.changeset(department, %{})
  end

  @doc """
  Возвращает поддерево подразделений относительно переданного пути.
  """
  def get_department_subtree!(path_from, depth) do
    Repo.all(
        if depth == "all" do
           from u in Department,
                  where: fragment("? <@ ?", u.path, ^path_from),
                  select: %{
                    id: u.id,
                    name: u.name,
                    parent_id: u.parent_id,
                    path: u.path,
                    parent_path: u.parent_path
                  }
        else
           searchPath = "#{path_from}.*{0,#{depth}}"
           from u in Department,
                  where: fragment("? ~ ?", u.path, ^searchPath),
                  select: %{
                    id: u.id,
                    name: u.name,
                    parent_id: u.parent_id,
                    path: u.path,
                    parent_path: u.parent_path
                  }
        end
    )
  end

  @doc """
  Удаляет подразделение вместе с его потомками
  """
  def delete_department_with_children!(path) do
    {:ok, _result} = Ecto.Adapters.SQL.query(PersonnelServer.Repo,  "DELETE FROM departments WHERE path <@ '#{path}'")
  end

  ############### ------------- Position  ----------------- ####

  def list_positions do
    Repo.all(Position)
  end

  def get_position!(id), do: Repo.get!(Position, id)

  def get_position_by_path!(path), do: Repo.get_by!(Position, path: path)

  def create_position(attrs \\ %{}) do
    %Position{}
    |> Position.changeset(attrs)
    |> Repo.insert(returning: true)
  end

  def update_position(%Position{} = position, attrs) do
    position
    |> Position.changeset(attrs)
    |> Repo.update()

    #Repo.preload(position, :department)
  end

  def delete_position(%Position{is_department_head: is_department_head} = position) do
    case is_department_head do
      false -> Repo.delete(position)
      true -> {:error, :head_position_directly_delete}
    end
  end

  def change_position(%Position{} = position) do
    Position.changeset(position, %{})
  end

  def get_position_subtree!(path_from, depth) do
    Repo.all(
        if depth == "all" do
           from u in Position,
           join: d in  assoc(u, :department),
                  where: fragment("? <@ ?", u.path, ^path_from),
                  preload: [department: d]
        else
           searchPath = "#{path_from}.*{0,#{depth}}"
           from u in Position,
                  where: fragment("? ~ ?", u.path, ^searchPath),
                  select: %{
                    id: u.id,
                    name: u.name,
                    parent_id: u.parent_id,
                    path: u.path,
                    parent_path: u.parent_path,
                    is_department_head: u.is_department_head,
                    department_id: u.department_id,
                  }
        end
    )
  end

  def delete_position_with_childs!(path) do
    %{is_department_head: is_department_head} = get_position_by_path!(path)

    case is_department_head do
      false -> {:ok, Ecto.Adapters.SQL.query(PersonnelServer.Repo,  "DELETE FROM positions WHERE path <@ '#{path}'")}
      true -> {:error, :head_position_directly_delete}
    end
  end
end
