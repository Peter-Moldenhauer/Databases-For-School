#1 Find all films with maximum length or minimum rental duration (compared to all other films). 
#In other words let L be the maximum film length, and let R be the minimum rental duration in the table film. You need to find all films that have length L or duration R or both length L and duration R.
#You just need to return attribute film id for this query. 

SELECT film_id FROM film 
WHERE length = (SELECT MAX(length) FROM film) 
OR rental_duration = (SELECT MIN(rental_duration) FROM film); 


#2 We want to find out how many of each category of film ED CHASE has started in so return a table with category.name and the count
#of the number of films that ED was in which were in that category order by the category name ascending (Your query should return every category even if ED has been in no films in that category).

SELECT x.name AS Category, COUNT(y.name) AS Count 
FROM (
   SELECT c.name
   FROM category c
) AS x
LEFT JOIN (
   SELECT c.name
   FROM category c
   INNER JOIN film_category fc ON c.category_id = fc.category_id
   INNER JOIN film f ON fc.film_id = f.film_id
   INNER JOIN film_actor fa ON f.film_id = fa.film_id
   INNER JOIN actor a ON fa.actor_id = a.actor_id
   WHERE a.first_name = 'ED' AND a.last_name = 'CHASE'
) AS y ON x.name = y.name
GROUP BY x.name
ORDER BY x.name;

#3 Find the first name, last name and total combined film length of Sci-Fi films for every actor
#That is the result should list the names of all of the actors(even if an actor has not been in any Sci-Fi films)and the total length of Sci-Fi films they have been in.

SELECT x.first_name AS FirstName, x.last_name AS LastName, y.total AS Total
FROM (
   SELECT a.first_name, a.last_name, a.actor_id
   FROM actor a
) AS x
LEFT JOIN (
   SELECT a.first_name, a.last_name, a.actor_id, SUM(f.length) AS total, c.name
   FROM category c
   INNER JOIN film_category fc ON c.category_id = fc.category_id
   INNER JOIN film f ON fc.film_id = f.film_id
   INNER JOIN film_actor fa ON f.film_id = fa.film_id
   INNER JOIN actor a ON fa.actor_id = a.actor_id
   WHERE c.name = 'Sci-Fi'
   GROUP BY a.actor_id
) AS y ON x.actor_id = y.actor_id;

#4 Find the first name and last name of all actors who have never been in a Sci-Fi film

SELECT a.first_name AS FirstName, a.last_name AS LastName
FROM actor a
WHERE a.actor_id NOT
IN (
    SELECT a.actor_id
    FROM film f
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    INNER JOIN film_actor fa ON f.film_id = fa.film_id
    INNER JOIN actor a ON fa.actor_id = a.actor_id
    WHERE c.name = 'Sci-Fi'
);

#5 Find the film title of all films which feature both KIRSTEN PALTROW and WARREN NOLTE
#Order the results by title, descending (use ORDER BY title DESC at the end of the query)
#Warning, this is a tricky one and while the syntax is all things you know, you have to think oustide
#the box a bit to figure out how to get a table that shows pairs of actors in movies

SELECT y.title AS FilmTitle
FROM (
    SELECT f.title, f.film_id
    FROM film f
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    INNER JOIN film_actor fa ON f.film_id = fa.film_id
    INNER JOIN actor a ON fa.actor_id = a.actor_id
    WHERE a.first_name = 'KIRSTEN' AND a.last_name = 'PALTROW'
) AS x
JOIN (
    SELECT f.title, f.film_id
    FROM film f
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    INNER JOIN film_actor fa ON f.film_id = fa.film_id
    INNER JOIN actor a ON fa.actor_id = a.actor_id
    WHERE a.first_name = 'WARREN' AND a.last_name = 'NOLTE'
) AS y ON x.film_id = y.film_id
ORDER BY y.title DESC;


