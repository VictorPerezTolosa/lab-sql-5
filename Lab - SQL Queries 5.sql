use sakila;

-- Instructions

-- 1. Drop column picture from staff.
select * from staff;
alter table staff drop column picture;
select * from staff;


-- 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.

select * from customer where first_name = "TAMMY" and last_name = "SANDERS"; -- Checking the information I have and what I miss
select * from staff;

insert into staff values -- I add a row in a table "staff"
(3, 
(select first_name from customer where first_name = "TAMMY" and last_name = "SANDERS"), -- getting the first name from another linked table
(select last_name from customer where first_name = "TAMMY" and last_name = "SANDERS"), -- the same for the last name
(select address_id from customer where first_name = "TAMMY" and last_name = "SANDERS"), -- and with the address
"Tammy.Sanders@sakilastaff.com",
2,
1,
"Tammy",
null,
"2022-08-29 10:34:16"
);

select * from staff; -- Now I just realized that I could capitalize the name and last name

update staff
set first_name = "Tammy", last_name = "Sanders"
where staff_id = 3;

select * from staff; -- Now it looks better


-- 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table. 
-- Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. 
-- For eg., you would notice that you need customer_id information as well. 
-- To get that you can use the following query:
-- select customer_id from sakila.customer where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
-- Use similar method to get inventory_id, film_id, and staff_id.

select * from rental; -- Checking the data I need
-- to get rental_id: (select max(rental_id)+1 from rental)
-- to get rental_date: current date
-- to get inventory_id: (select inventory_id from inventory where store_id = 1 and film_id = (select film_id from film where title = "Academy Dinosaur") order by rand() limit 1)
-- to get customer_id: (select customer_id from customer where first_name = 'CHARLOTTE' and last_name = 'HUNTER')
-- to get return_date: null
-- to get staff_id: (select staff_id from staff where first_name = 'Mike' and last_name = 'Hillyer')
-- to get last_update: current date

-- And here we go:
insert into rental values -- Creating a new row in "rental" table
(16050, -- Quering from the same table gives an error so I put the number manually
"2022-08-29 10:34:16",
(select inventory_id from inventory where store_id = 1 and film_id = (select film_id from film where title = "Academy Dinosaur") order by rand() limit 1),
(select customer_id from customer where first_name = 'CHARLOTTE' and last_name = 'HUNTER'),
null,
(select staff_id from staff where first_name = 'Mike' and last_name = 'Hillyer'),
"2022-08-29 10:34:16"
);

select * from rental order by rental_id desc limit 1; -- Checking the new row


-- 4. Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:

-- Check if there are any non-active users
select * from customer where active = 0;

-- Create a table backup table as suggested
-- Insert the non active users in the table backup table
drop table if exists deleted_users;
create table deleted_users as select customer_id, email from customer where active = 0;
select * from deleted_users; -- First check
alter table deleted_users add date datetime;
update deleted_users set date = "2022-08-29 10:34:16";
select * from deleted_users; -- Second check

-- Delete the non active users from the table customer
select * from customer order by active; -- First check
delete from customer where active = 0; -- It gives me Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`payment`, CONSTRAINT `fk_payment_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE)	0.000 sec
set foreign_key_checks = 0; -- Disable the foreign key checks
delete from customer where active = 0; -- Repeat the statement
set foreign_key_checks = 1; -- Enable foreign key cheks again
select * from customer order by active; -- Second check



