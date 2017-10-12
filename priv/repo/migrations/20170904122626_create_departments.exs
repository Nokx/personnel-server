defmodule PersonnelServer.Repo.Migrations.CreateDepartments do
  use Ecto.Migration

  def change do
    create table(:departments) do
      add :name, :string
      add :path, :ltree
      add :parent_path, :ltree
      add :parent_id, references(:departments) 

      timestamps()
    end

    create index(:departments, [:path], using: :gist)
    create index(:departments, [:parent_path], using: :gist)
    create index(:departments, [:parent_id])

  end
end
