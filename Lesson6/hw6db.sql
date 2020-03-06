use vk3;

-- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека,
-- который больше всех общался с нашим пользователем.

select id
	, count(*) as allmassages
	from messages
	where 
		(from_user_id in (
			-- выбираем из пользователей, писавших нашему юзеру только тех, кто является другом
			select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved' 
			union
			select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved'
			and to_user_id = 1))
		or
		(to_user_id in (
			-- выбираем из пользователей, которым писал наш юзеру только тех, кто является другом
			select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved'
			union
			select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved'
			and from_user_id = 1))
	group by from_user_id
	order by allmassages desc
	limit 1;
	
-- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.

select
	*
from likes
where id IN (
	select 
	user_id 
	from profiles 
	where TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10
);


-- Определить кто больше поставил лайков (всего) - мужчины или женщины?
select 
	count
	, gender
from (
		select 
			count(*) as count
			, 'male' as gender
		from likes
		where id in (
			select 
				user_id
			from profiles
			where gender='m')
	union all
		select 
			count(*) as c
			, 'female' as gender
		from likes
		where id in (
			select 
				user_id 
			from profiles
			where gender='f')
	) as d
order by count desc
limit 1 

