use vk_kurs;

-- 1.1. Процедура поиска пользователей с общим городом или общей группой или являющихся друзьями друзей.

drop procedure if exists friendship_offers;

delimiter //
create procedure friendship_offers(in the_user INT)
  begin
	-- общий город
	select p2.user_id
	from profiles p1
	join profiles p2 
	    on p1.hometown = p2.hometown
	where p1.user_id = the_user 
	    and p2.user_id != the_user -- исключим себя
	
		union 
		
	-- общие группы
	select uc2.user_id
	from users_communities uc1
	join users_communities uc2 
	    on uc1.community_id = uc2.community_id
	where uc1.user_id = the_user 
	    and uc2.user_id <> the_user -- исключим себя

		union 
		
	-- друзья друзей
	-- получим друзей друзей
	-- объединяем таблицу саму с собой 3 раза
	-- фильтруем «первую» таблицу по the_user
	select fr3.target_user_id	
	from friend_requests fr1
		join friend_requests fr2 
		    on (fr1.target_user_id = fr2.initiator_user_id 
		        or fr1.initiator_user_id = fr2.target_user_id)
		join friend_requests fr3 
		    on (fr3.target_user_id = fr2.initiator_user_id 
		        or fr3.initiator_user_id = fr2.target_user_id)
	where (fr1.initiator_user_id = the_user or fr1.target_user_id = the_user)
	 	and fr2.status = 'approved' -- оставляем только подтвержденную дружбу
	 	and fr3.status = 'approved'
		and fr3.target_user_id <> the_user -- исключим себя
	order by rand()
	limit 5
	;
end//
delimiter ;

call friendship_offers(1);


-- 1.2. Процедура подсчета просмотров контента у указанного пользователя

drop procedure if exists user_popularity;
delimiter //
create procedure user_popularity(in one_user_id int)
begin
	select
		concat (u.firstname, ' ', u.lastname) as name
		, count(*) as views_counter
	from views v
	join media m
		on v.media_id = m.id 
	join users u
	  	on m.user_id = u.id
	  	where u.id = one_user_id
	group by m.user_id;
end//

call user_popularity(1);
delimiter ;

-- 2.1. Триггер, запрещающий обновление таблицы неверной датой рождения.
DROP TRIGGER IF EXISTS vk_kurs.true_birthday_sample;

DELIMITER $$
$$
CREATE TRIGGER true_birthday_sample
before update
ON profiles FOR EACH row
begin
	if new.birthday >= current_date() then
	signal sqlstate '45000' set message_text = 'Update canceled. You can\'t have birthday in the future';
	end if;
end$$
DELIMITER ;

-- проверка
update profiles 
set birthday='2020.03.05'
where user_id = 1;

-- 2.2. Триггер, запрещающий вставлять данные в media с ошибочной датой создания created_at

DROP TRIGGER IF EXISTS vk_kurs.true_created_time;

DELIMITER $$
$$
create trigger true_created_time
before insert
on media for EACH row
begin
	if new.created_at >= current_date() then
	signal sqlstate '45000' set message_text = 'Update canceled. You can\'t insert in the future';
	end if;
end$$
DELIMITER ;
 
-- проверка
INSERT INTO `media` VALUES ('120','1','1','Id','quis.jpg','2965434',NULL,'2020-03-19 21:24:09','1975-09-12 23:09:56');

-- 2.3 . Триггер, запрещающий вставлять данные в media с ошибочным расширением файла

DROP TRIGGER IF EXISTS vk_kurs.true_filename;

DELIMITER $$
$$
create trigger true_filename
before insert
on media for EACH row
begin
	if new.filename not like '%.jpg'
	and new.filename not like '%.mp3' 
	and new.filename not like '%.txt' 
	and new.filename not like '%.avi'
	then
	signal sqlstate '45000' set message_text = 'Insert canceled. The file must have an extension';
	end if;
end$$
DELIMITER ;

-- проверка
INSERT INTO `media` VALUES ('121','1','1','Id','quis.avi','2965434',NULL,'2020-03-19 21:24:09','1975-09-12 23:09:56');
