use shop;

-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
-- 1) через вложенные запросы
select
	id
	, name
from users
where id in (select user_id from orders);
-- 2) через объединение таблиц
select DISTINCT 
	u.id
	, u.name
from
	users u
inner join
	orders o
 on
 	u.id = o.user_id


-- Выведите список товаров products и разделов catalogs, который соответствует товару.

 	select 
 		p.name as 'Товар'
 		, c.name as 'Раздел' 
 	from
 		products p 
 	join
 		catalogs c
 	on
 		p.catalog_id = c.id 
 	
 
 	-- Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
 	-- Поля from, to и label содержат английские названия городов, поле name — русское. 
 	-- Выведите список рейсов flights с русскими названиями городов.

 create database fly;
 use fly;

drop table if exists flights;
create table flights (
	id serial primary key,
	fromcity text,
	tocity text
);

insert into flights values
(null, 'moscow', 'omsk' ),
(null, 'novgorod', 'kazan' ),
(null, 'irkutsk', 'moscow' ),
(null, 'omsk', 'irkutsk' ),
(null, 'moscow', 'kazan' );

drop table if exists cities;
create table cities (
	label text,
	name text
);

insert into cities values
('moscow', 'Москва' ),
('irkutsk', 'Иркутск' ),
('novgorod', 'Новгород' ),
('kazan', 'Казань' ),
('omsk', 'Омск' );

select 
	a.id
	, b.c2 as departure
	, a.c1 as arrival
from 
(select
	id
	, c.name as c1
from
	flights f
join
	cities c
on
	f.tocity = c.label
order by id) as a,
(select
	id 
	, c.name as c2
from 
	flights f 
join
	cities c
on
	f.fromcity = c.label
order by id) as b
where
a.id = b.id
order by id

-- через объединение таблиц
select 
	a.id
	, b.c2 as departure
	, a.c1 as arrival
from 
(select
	id
	, c.name as c1
from
	flights f
join
	cities c
on
	f.tocity = c.label
order by id) as a
join
(select
	id 
	, c.name as c2
from 
	flights f 
join
	cities c
on
	f.fromcity = c.label
order by id) as b
on
a.id = b.id
order by id



