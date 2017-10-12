defmodule PersonnelServer.Repo.Migrations.AddAfterDepartmentChangeTrg do
  use Ecto.Migration

  def up do
    execute "
      CREATE OR REPLACE FUNCTION actions_after_department_changed() RETURNS TRIGGER AS $$
                DECLARE
                    ppath ltree;
                    pos_id integer;
                    new_parent_pos_id integer;
                    pos_path ltree;
                    pos_parent_id integer;
                BEGIN
                    IF TG_OP = 'UPDATE' THEN
                        IF NEW.parent_id != OLD.parent_id THEN
                            SELECT id from positions WHERE is_department_head = true AND department_id = OLD.id into pos_id;
                            SELECT id from positions WHERE is_department_head = true AND department_id = NEW.parent_id into new_parent_pos_id;

                            UPDATE positions SET parent_id = new_parent_pos_id WHERE id = pos_id;
                        END IF;
                    END IF;

                    IF TG_OP = 'INSERT' THEN
                    	IF NEW.parent_id IS NULL THEN
                        	INSERT INTO positions (name, department_id, is_department_head, inserted_at, updated_at)
                            		VALUES ('Руководитель подразделения '||NEW.name, NEW.id, true, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
                        ELSE
                        	SELECT id FROM positions WHERE is_department_head = true AND department_id = NEW.parent_id into pos_parent_id;
                        	INSERT INTO positions (name, parent_id, department_id, is_department_head, inserted_at, updated_at)
                            		VALUES ('Руководитель подразделения '||NEW.name, pos_parent_id, NEW.id, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
                        END IF;
                    END IF;


                    RETURN NULL;
                END;
            $$ LANGUAGE plpgsql;"

    execute "
      CREATE TRIGGER after_department_changed_trg
          AFTER INSERT OR DELETE OR UPDATE ON departments
          FOR EACH ROW EXECUTE PROCEDURE actions_after_department_changed(); "
  end

  def down do
    execute "DROP TRIGGER after_department_changed_trg ON departments"
    execute "DROP FUNCTION actions_after_department_changed()"
  end
end
