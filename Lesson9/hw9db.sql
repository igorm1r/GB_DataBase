use shop;

-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;
delete from sample.users where id=1;
INSERT INTO sample.users SELECT id, name from shop.users WHERE id=1;
commit;

-- Создайте представление, которое выводит название name товарной позиции из таблицы products 
-- и соответствующее название каталога name из таблицы catalogs.

CREATE OR REPLACE VIEW shop.vw_name_of_products_catalogs
AS select 
	products.name as name_products
	, catalogs.name as name_catalogs
from
	catalogs
	join
	products
	on
	catalogs.id = products.catalog_id;

/* Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
с 18:00 до 00:00 — "Добрый вечер",
с 00:00 до 6:00 — "Доброй ночи". */
select current_time()

delimiter //
drop function if exists hello//
create function hello()
returns text deterministic
begin
	declare a time default current_time();
	if (a >= '06:00:00') and (a < '12:00:00') then
		return 'Доброе утро';
	elseif (a >= '12:00:00') and (a < '18:00:00') then
		return 'Добрый день';
	elseif (a >= '18:00:00') and (a <= '23:59:59') then
		return 'Добрый вечер';
	else return 'Доброй ночи';
	end if;
end // 
delimiter ;

-- проверка
select hello()

/* В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
 Допустимо присутствие обоих полей или одно из них. 
 Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
 Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
 При попытке присвоить полям NULL-значение необходимо отменить операцию.
 */

drop TRIGGER if exists fill_the_products;

DELIMITER //

CREATE TRIGGER fill_the_products BEFORE INSERT ON products
FOR EACH ROW
begin
    IF NEW.name is null and new.description is null THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Update Canceled. One of the fields "Name" or "Description" must be filled!';
    END IF;
END//

DELIMITER ;

drop TRIGGER if exists update_the_products;

DELIMITER //

CREATE TRIGGER update_the_products BEFORE update ON products
FOR EACH ROW
begin
    IF NEW.name is null and new.description is null THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Update Canceled. One of the fields "Name" or "Description" must be filled!';
    END IF;
END//

DELIMITER ;

-- проверка 
insert into products (name, description) values (null, null);
update products set name = null, description = null where id = 1;

	