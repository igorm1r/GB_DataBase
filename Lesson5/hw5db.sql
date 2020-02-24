drop database if exists lesson5;
create database if not exists lesson5;
use lesson5;

drop table if exists users;
create table if not exists users (
name VARCHAR(115),
created_at VARCHAR (115),
updated_at VARCHAR (115)
);

insert into users 
values
('Igor','',''),
('Nikita','',''),
('Alex', '20.10.2017 8:10', '20.10.2017 8:10'),
('Anna','',''),
('Alexander','20.10.2017 8:10','20.10.2017 8:10');

/* Пусть в таблице users поля created_at и updated_at
  оказались незаполненными. Заполните их текущими датой и временем. */

update users 
set
created_at = now(),
updated_at = now();

/* Таблица users была неудачно спроектирована. 
Записи created_at и updated_at были заданы типом VARCHAR
и в них долгое время помещались значения в формате "20.10.2017 8:10". 
Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения. */

update users 
set
created_at = '21.10.2017 8:10',
updated_at = '21.10.2017 8:10'
where name = 'Igor';

update users 
set
created_at = '22.10.2017 8:10',
updated_at = '22.10.2017 8:10'
where name = 'Nikita';

update users
set
created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');

/*В таблице складских запасов storehouses_products
 в поле value могут встречаться самые разные цифры:
  0, если товар закончился и выше нуля, если на складе имеются запасы. 
  Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
 Однако, нулевые запасы должны выводиться в конце, после всех записей.*/

drop table if exists storehouses_products;
create table if not exists storehouses_products (
name VARCHAR(115),
store Int(8)
);

insert into storehouses_products 
values
('PCs', '5'),
('Printers', '0'),
('Laptops', '10'),
('Keys','0'),
('Mouses','2000');


select * from storehouses_products
order by if (store>0, 0, 1), store;

/* (по желанию) Из таблицы users необходимо извлечь пользователей, 
родившихся в августе и мае. Месяцы заданы в виде списка 
английских названий ('may', 'august') */

drop table if exists users;
create table if not exists users (
id SERIAL PRIMARY KEY,
name VARCHAR(115),
birthday_date DATE
);

insert into users (name, birthday_date)
values
('Igor','1990-05-06'),
('Nikita','1995-08-23'),
('Alex', '1990-12-06'),
('Anna','1966-05-06'),
('Alexander','1969-03-16');

select * from users where date_format(birthday_date, '%M')='may' or date_format(birthday_date, '%M')='august'

/* (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
Отсортируйте записи в порядке, заданном в списке IN. */

drop table if exists catalogs;
create table if not exists catalogs (
id SERIAL PRIMARY KEY,
name VARCHAR(115),
store Int(8)
);

insert into catalogs (name, store)
values
('PCs', '5'),
('Printers', '0'),
('Laptops', '10'),
('Keys','0'),
('Mouses','2000');

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2); 

/*2.1 Подсчитайте средний возраст пользователей в таблице users*/

alter table users drop column age;
alter table users add age int(11) default null;
update users
set age= TIMESTAMPDIFF(YEAR,birthday_date ,CURDATE())

SELECT SUM(age)/MAX(id) FROM users

/*2.2. Подсчитайте количество дней рождения, которые приходятся на каждый
 из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/

-- select birthday_date from users where weekday(date_format(birthday_date, '2020-%m-%d'))=2

alter table users drop column dow;
alter table users add dow int(11) default null;
update users
set dow=weekday(date_format(birthday_date, '2020-%m-%d'))

Select dow, count(*) from users group by dow

/* (по желанию) Подсчитайте произведение чисел в столбце таблицы */

select exp(sum(ln(id))) from users

















































