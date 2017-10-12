defmodule PersonnelServer.Repo.Migrations.AddBeforeDepartmentDeleteTrg do
  use Ecto.Migration

  def up do
    execute "
      CREATE OR REPLACE FUNCTION actions_before_department_delete() RETURNS TRIGGER AS $$
                DECLARE
                    pos_path ltree;
                BEGIN
                 	IF TG_OP = 'DELETE' THEN
                    	SELECT path from positions WHERE is_department_head = true AND department_id = OLD.id into pos_path;
                    	DELETE FROM positions WHERE path <@ pos_path;
                    END IF;

                    RETURN OLD;
                END;
            $$ LANGUAGE plpgsql;"

    execute "
      CREATE TRIGGER before_department_delete_trg
          BEFORE DELETE ON departments
          FOR EACH ROW EXECUTE PROCEDURE actions_before_department_delete(); "
  end

  def down do
    execute "DROP TRIGGER before_department_delete_trg ON departments"
    execute "DROP FUNCTION actions_before_department_delete()"
  end
end
