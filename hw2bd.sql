/* ������ 2
�������� ���� ������ example, ���������� � ��� ������� users, 
��������� �� ���� ��������, ��������� id � ���������� name.
*/

create database example;
use example;
create table users (
	id INT auto_increment primary key,
	name varchar(100) not null
);