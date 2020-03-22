use vk_kurs;

-- 1. Представление, показывающее друзей пользователя 
CREATE OR replace VIEW view_friends
AS 
  select *
  FROM users u
    JOIN friend_requests fr ON u.id = fr.target_user_id
  WHERE 
  fr.status = 'approved'

  	union
  	
  select *
  FROM users u
    JOIN friend_requests fr ON u.id = fr.initiator_user_id
  WHERE 
  fr.status = 'approved';
  
-- проверка
  select vf.* from view_friends vf;
  
-- 2. Представление, которое выводит логин пользователя из таблицы users и его количество картинок из таблицы media.
CREATE OR replace VIEW view_count_pictures
as
select 
	concat (u.firstname, ' ', u.lastname) as name
	, count(*) as pictures
from media m 
join media_types mt
join users u
on m.media_type_id = mt.id and u.id = mt.id
where mt.name = 'Pictures'
group by user_id;

-- проверка
select * from view_count_pictures;

-- 3. Представление по поиску 5 пользователей с наиболее просматриваемым контентом.
CREATE OR replace VIEW views_counter
as
	select
		concat (u.firstname, ' ', u.lastname) as name
		, count(*) as views_counter
	from views v
	join media m
		on v.media_id = m.id 
	join users u
	  	on m.user_id = u.id
	group by m.user_id 
	order by views_counter desc
	limit 5;

-- проверка
select * from views_counter;