defmodule PersonnelServer.Repo.Migrations.AddPositionPathTrg do
  use Ecto.Migration

  def up do
    execute "
      CREATE OR REPLACE FUNCTION update_position_path() RETURNS TRIGGER AS $$
                DECLARE
                    ppath ltree;
                    pos_department_path_level integer;
                    pos_new_parent_path_level integer;
                    dep_id integer;
                BEGIN
                	-- Позицию должности, руководящей подразделением можно изменять, только через изменение позиции подразделения
                	IF TG_OP = 'UPDATE' AND OLD.is_department_head = true AND NEW.parent_id != OLD.parent_id THEN
                    	-- сравним уровень соответствующего должности подразделения и новый уровень должности
                        -- если они равны, то тогда событие было вызвано изменением позиции подразделения и можно перемещать
                        -- если они разные, то значит должности перенести отдельно от подразделения и сообщаем об ошибке.

                        SELECT nlevel(path) FROM departments where id = OLD.department_id into pos_department_path_level;
                        SELECT nlevel(path) + 1 FROM positions where id = NEW.parent_id into pos_new_parent_path_level;

                        IF pos_department_path_level != pos_new_parent_path_level THEN
                            RAISE EXCEPTION 'Запрещено переносить должность, соответствующую руководителю подразделения. Позицию можно менять через изменение позиции подразделения';
                        END IF;
                    END IF;

                    IF NEW.parent_id IS NULL THEN
                        NEW.parent_path = 'root'::ltree;
                        NEW.path = 'root'::ltree || NEW.id::text;
                    ELSEIF TG_OP = 'INSERT' OR OLD.parent_id IS NULL OR OLD.parent_id != NEW.parent_id THEN
                        SELECT parent_path || id::text FROM positions WHERE id = NEW.parent_id INTO ppath;
                        IF ppath IS NULL THEN
                            RAISE EXCEPTION 'Invalid parent_id %', NEW.parent_id;
                        END IF;
                        NEW.path = ppath || NEW.id::text;
                        NEW.parent_path = ppath;

						-- Если создается новая должность, то если она руководящая для подразделеняи, то department_id должен быть передан, иначе ошибка
                        -- Если создается обычная должность, то department_id должен браться из родительской должности
                        IF TG_OP = 'INSERT' THEN
                        	IF NEW.is_department_head = true AND NEW.department_id IS NULL THEN
                            	RAISE EXCEPTION 'Руководящей должности должно быть передано подразделение';
                            END IF;
                            IF NEW.is_department_head = false THEN
                            	SELECT department_id from positions WHERE id = NEW.parent_id into dep_id;
                           		NEW.department_id = dep_id;
                            END IF;
                        END IF;

						IF TG_OP = 'UPDATE'  THEN
                           IF OLD.is_department_head = true THEN
                            UPDATE positions SET
                                   path = replace(ltree2text(path), ltree2text(OLD.path), ltree2text(NEW.path))::ltree,
                                   parent_path = replace(ltree2text(parent_path), ltree2text(OLD.parent_path), ltree2text(ppath))::ltree
                            WHERE path <@ OLD.path and id != OLD.id;
                           ELSE
                             SELECT department_id from positions WHERE id = NEW.parent_id into dep_id;
                             UPDATE positions SET
                                 path = replace(ltree2text(path), ltree2text(OLD.path), ltree2text(NEW.path))::ltree,
                                 parent_path = replace(ltree2text(parent_path), ltree2text(OLD.parent_path), ltree2text(ppath))::ltree,
                                 department_id = dep_id
                             WHERE path <@ OLD.path and id != OLD.id;
                           END IF;
                        END IF;
                    END IF;
                    RETURN NEW;
                END;
            $$ LANGUAGE plpgsql;"

    execute "
      CREATE TRIGGER position_path_trg
          BEFORE INSERT OR UPDATE ON positions
          FOR EACH ROW EXECUTE PROCEDURE update_position_path(); "
  end

  def down do
    execute "DROP TRIGGER position_path_trg ON positions"
    execute "DROP FUNCTION update_position_path()"
  end
end
