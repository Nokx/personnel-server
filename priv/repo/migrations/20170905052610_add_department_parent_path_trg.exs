defmodule PersonnelServer.Repo.Migrations.AddDepartmentParentPathTrg do
  use Ecto.Migration

  def up do
    execute "
      CREATE OR REPLACE FUNCTION update_department_parent_path() RETURNS TRIGGER AS $$
            DECLARE
                ppath ltree;
                pos_parent_id integer;
                root_id integer;
            BEGIN
                IF NEW.parent_id IS NULL THEN
                    SELECT id from departments WHERE parent_id IS NULL INTO root_id;
                    IF root_id IS NOT NULL THEN
                            IF (TG_OP = 'UPDATE' AND root_id != OLD.id) OR TG_OP = 'INSERT' THEN
                                RAISE EXCEPTION 'Возможно создать только одно корневое подразделение';
                            END IF;
                        ELSE	
                            NEW.parent_path = 'root'::ltree;
                            NEW.path = 'root'::ltree || NEW.id::text;
                    END IF;
                ELSEIF TG_OP = 'INSERT' OR OLD.parent_id IS NULL OR OLD.parent_id != NEW.parent_id THEN
                    SELECT parent_path || id::text FROM departments WHERE id = NEW.parent_id INTO ppath;
                    IF ppath IS NULL THEN
                        RAISE EXCEPTION 'Invalid parent_id %', NEW.parent_id;
                    END IF;
                    NEW.path = ppath || NEW.id::text;
                    NEW.parent_path = ppath;

                    IF TG_OP = 'UPDATE'  THEN
                        UPDATE departments SET
                          path = replace(ltree2text(path), ltree2text(OLD.path), ltree2text(NEW.path))::ltree,
                            parent_path = replace(ltree2text(parent_path), ltree2text(OLD.parent_path), ltree2text(ppath))::ltree
                        WHERE path <@ OLD.path and id != OLD.id;
                    END IF;
                END IF;
                RETURN NEW;
            END;
        $$ LANGUAGE plpgsql;"

    execute "
      CREATE TRIGGER parent_path_tgr
          BEFORE INSERT OR UPDATE ON departments
          FOR EACH ROW EXECUTE PROCEDURE update_department_parent_path(); "
  end

  def down do
    execute "DROP TRIGGER parent_path_tgr ON departments"
    execute "DROP FUNCTION update_department_parent_path()"
  end
end
