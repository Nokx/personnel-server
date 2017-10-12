defmodule PersonnelServer.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def change do
    create table(:positions) do
      add :name, :string
      add :path, :ltree, null: false
      add :parent_path, :ltree, null: false
      add :parent_id, references(:positions)
      add :department_id, references(:departments), null: false
      add :is_department_head, :boolean, default: false

      timestamps()
    end

    create index(:positions, [:path], using: :gist)
    create index(:positions, [:parent_path], using: :gist)
    create index(:positions, [:parent_id])

  end
end
