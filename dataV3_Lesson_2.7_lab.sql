drop table if exists films_2020;
CREATE TABLE `films_2020` (
  `film_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `release_year` year(4) DEFAULT NULL,
  `language_id` tinyint(3) unsigned NOT NULL,
  `original_language_id` tinyint(3) unsigned DEFAULT NULL,
  `rental_duration` int(6),
  `rental_rate` decimal(4,2),
  `length` smallint(5) unsigned DEFAULT NULL,
  `replacement_cost` decimal(5,2) DEFAULT NULL,
  `rating` enum('G','PG','PG-13','R','NC-17') DEFAULT NULL,
  PRIMARY KEY (`film_id`),
  CONSTRAINT FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8;



use sakila;

show variables like 'local_infile';
set global local_infile = 1;

load data local infile'/Users/felixley/Ironhack/Data_Analytics_Course/Week2/Day4/dataV3_Lesson_2.7_lab/files_for_part1/films_2020.csv' -- provide the complete path of the file
into table films_2020
fields terminated BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(film_id,title,description,release_year,language_id,original_language_id,rental_duration,rental_rate,length,replacement_cost,rating);

select rental_duration, rental_rate, replacement_cost from sakila.films_2020;

UPDATE sakila.films_2020 SET rental_duration = 3;
UPDATE sakila.films_2020 SET rental_rate = 2.99;
UPDATE sakila.films_2020 SET replacement_cost = 8.99;


select * from sakila.films_2020;

-- Part 2

-- In the table actor, which are the actors whose last names are not repeated? 
-- For example if you would sort the data in the table actor by last_name, 
-- you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. 
-- These three actors have the same last name. So we do not want to include this last name in our output. 
-- Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list.
select  count(last_name) as 'No', last_name
from sakila.actor
group by last_name 
having count(last_name) = 1;



-- Which last names appear more than once? We would use the same logic as in the previous question but this time 
-- we want to include the last names of the actors where the last name was present more than once
select  count(last_name) as 'No', last_name
from sakila.actor
group by last_name 
having count(last_name) > 1
order by 'No' desc;


-- Using the rental table, find out how many rentals were processed by each employee.
select staff_id, count(rental_id) as NoRentals
from sakila.rental
Group by staff_id;


-- Using the film table, find out how many films were released each year.
select release_year as Year, count(film_id) as NoFilms
from sakila.film
group by Year
order by NoFilms desc;


-- Using the film table, find out for each rating how many films were there.
select rating, count(film_id) as NoFilms
from sakila.film
group by rating
order by NoFilms desc;

-- What is the mean length of the film for each rating type. Round off the average lengths to two decimal places
select rating, round(avg(length),2) as AvgLength
from sakila.film
group by rating
order by avg(length) desc;

-- Which kind of movies (rating) have a mean duration of more than two hours?
select rating, round(avg(length)) as AvgLength
from sakila.film
group by rating
having avg(length) >= 120;
