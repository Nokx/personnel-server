defmodule PersonnelServer.Orgstructure.Department do
  use Ecto.Schema
  import Ecto.Changeset
  alias PersonnelServer.Orgstructure.Department


  schema "departments" do
    field :name, :string
    field :parent_path, :string, read_after_writes: true
    field :path, :string, read_after_writes: true

    has_many :positions, PersonnelServer.Orgstructure.Position

    belongs_to :parent, PersonnelServer.Orgstructure.Department
    has_many :child_departments, PersonnelServer.Orgstructure.Department, foreign_key: :parent_id

    timestamps()
  end

  @doc false
  def changeset(%Department{} = department, attrs) do
    department
    |> cast(attrs, [:name, :parent_id])
    |> validate_required([:name])
  end
end
