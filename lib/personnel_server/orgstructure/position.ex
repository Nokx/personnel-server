defmodule PersonnelServer.Orgstructure.Position do
    use Ecto.Schema
    import Ecto.Changeset
    alias PersonnelServer.Orgstructure.Position

    schema "positions" do
        field :name, :string
        field :parent_path, :string, read_after_writes: true
        field :path, :string, read_after_writes: true
        field :is_department_head, :boolean

        field :department_id, :integer, read_after_writes: true
        belongs_to :department, PersonnelServer.Orgstructure.Department, define_field: false

        belongs_to :parent, PersonnelServer.Orgstructure.Position
        has_many :child_departments, PersonnelServer.Orgstructure.Position, foreign_key: :parent_id

        timestamps()
    end

    @doc false
    def changeset(%Position{} = position, attrs) do
        position
        |> cast(attrs, [:name, :parent_id, :is_department_head])
        |> validate_required([:name])
    end
end
