/* Задача 2
Создайте базу данных example, разместите в ней таблицу users, 
состоящую из двух столбцов, числового id и строкового name.
*/

create database example;
use example;
create table users (
	id INT auto_increment primary key,
	name varchar(100) not null
);