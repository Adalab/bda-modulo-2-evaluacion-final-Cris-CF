
/****************************************
        TECHNICAL EXERCISE     
	 SQL using the Sakila DB
 ****************************************/

-- First we go to Sakila DB:
USE sakila;

-- We will use these tables:
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film;
SELECT * FROM rental;


-- =============================================--
-- 1. Select all movie names without duplicates --
-- =============================================--

SELECT DISTINCT f.title
FROM film f;


-- ============================================================--
-- 2. Show the names of all movies that have a "PG-13" rating --
-- ============================================================--

SELECT 
f.title,
f.rating
FROM film f
WHERE f.rating = 'PG-13';


-- =====================================================================================================--
-- 3. Find the title and description of all movies that contain the word "amazing" in their description --
-- =====================================================================================================--

SELECT 
f.title,
f.description AS 'Description containing "Amazing"'
FROM film f
WHERE f.description LIKE '%amazing%';


-- =================================================================--
-- 4. Find the title of all movies that are longer than 120 minutes --
-- =================================================================--

SELECT 
f.title,
f.length
FROM film f
WHERE f.length >= 120;


-- ============================================================================================================================--
-- 5. Find the names of all the actors, display them in a single column called 'actor_name' and containing first and last name --
-- ============================================================================================================================--

SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM actor a;


-- =====================================================================================
-- 6. Find the first and last name of actors who have "Gibson" in their last name
-- =====================================================================================

SELECT
a.first_name,
a.last_name
FROM actor a
WHERE a.last_name LIKE '%Gibson%';  -- It can also be done with "IN", "=" and "Regex"


-- ====================================================================--
-- 7. Find the names of actors that have an actor_id between 10 and 20 --
-- ====================================================================--

SELECT 
a.first_name,
a.actor_id
FROM actor a
WHERE a.actor_id >= 10 AND a.actor_id <= 20;


-- =====================================================================================--
-- 8. Find the title in the "Movies" table for those that are not rated "R" or "PG-13." --
-- =====================================================================================--

SELECT 
f.title,
f.rating
FROM film f
WHERE f.rating != 'PG-13' AND f.rating != 'R';


-- =====================================================================================================================================
-- 9. Find the total number of movies in each rating from the Film table and displays the rating along with the count.
-- =====================================================================================================================================

SELECT
f.rating,
COUNT(f.film_id) AS Total_Films
FROM film f
GROUP BY f.rating;


-- =====================================================================================================================================================--
-- 10. Find the total number of movies rented by each customer and displays the customer ID, first and last name along with the number of movies rented --
-- =====================================================================================================================================================--

SELECT
c.customer_id,
c.first_name,     
c.last_name,
COUNT(r.rental_id) AS Total_Rents
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY r.customer_id;


-- =================================================================================================================--
-- 11. Find the total number of movies rented by category and display the category name along with the rental count --
-- =================================================================================================================--

SELECT
COUNT(r.rental_id) AS Total_Rents,
c.name
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id -- linking category table with film_category table 
INNER JOIN inventory i
ON fc.film_id = i.film_id -- now with inventory table using the film_id column
INNER JOIN rental r
ON i.inventory_id = r.inventory_id -- and finnally we connect it with rental table 
GROUP BY c.name;


-- ============================================================================================================================--
-- 12. Find the average length of films for each rating in the film table and display the rating along with the average length --
-- ============================================================================================================================--

SELECT
AVG(f.length) AS Average_Length,
f.rating
FROM film f
GROUP BY f.rating;


-- ================================================================================================--
-- 13. Find the first and last name of the actors who appear in the movie with title "Indian Love" --
-- ================================================================================================--

SELECT
CONCAT(a.first_name, ' ', a.last_name) AS 'Indian Love Cast:'
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
INNER JOIN film f 
ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love';


-- ==============================================================================================--
-- 14. Display the title of all movies that contain the word "dog" or "cat" in their description --
-- ==============================================================================================--

SELECT
f.title,
f.description
FROM film f
WHERE f.description regexp 'dog|cat';


-- =========================================================================================--
-- 15. Is there an actor or actress who did not appear in any film in the film_actor table? --
-- =========================================================================================--

SELECT
a.first_name,
a.last_name
FROM actor a
LEFT JOIN film_actor fa   -- it returns all results not just those where there are matches, it will return even those that do not have any associated movie
ON fa.actor_id = a.actor_id
WHERE fa.actor_id IS NULL; -- if it is empty it means that all actors and actresses have acted in at least one film


-- =======================================================================================--
-- 16. Find the title of all the movies that were released between the year 2005 and 2010 --
-- =======================================================================================--

SELECT f.title FROM film f
WHERE f.release_year BETWEEN 2005 AND 2010;


-- ===========================================================================--
-- 17. Find the title of all movies that are in the same category as "Family" --
-- ===========================================================================--

SELECT
f.title
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = 'Family';


-- ============================================================================--
-- 18. Show the first and last name of actors who appear in more than 10 films --
-- ============================================================================--

SELECT
CONCAT(a.first_name, ' ', a.last_name) AS Full_Name
FROM actor a
INNER JOIN film_actor fa
ON fa.actor_id = a.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id
GROUP BY Full_Name
HAVING COUNT(f.film_id) > 10;


-- ================================================================================--
-- 19. Find the title of all movies rated "R" and over 2 hours in the movies table --
-- =================================================================================--

SELECT
f.title  -- we can put here also f.rating and f.length to check the results
FROM film f
GROUP BY f.title, f.rating, f.length
HAVING f.rating = 'R' AND f.length >= 180;


-- ============================================================================================================================================--
-- 20. Finds movie categories that have an average length greater than 120 minutes and display the category name along with the average length --
-- ============================================================================================================================================--

SELECT 
c.name AS category, 
AVG(f.length) AS average_length
FROM film f
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category c 
ON fc.category_id = c.category_id
GROUP BY category
HAVING AVG(f.length) > 120;


-- ===================================================================================================================================--
-- 21. Find actors who have acted in at least 5 movies and shows the actor's name along with the number of movies they have acted in --
-- ==================================================================================================================================--

SELECT
a.first_name, 
a.last_name,
COUNT(f.film_id) AS Total_Films
FROM actor a
INNER JOIN film_actor fa 
ON fa.actor_id = a.actor_id
INNER JOIN film f 
ON fa.film_id = f.film_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(f.film_id) >= 5;


-- ===================================================================================================================--
-- 22. Find the title of all movies that were rented for more than 5 days.                                            --
--     Use a subquery to find rental_ids with a duration greater than 5 days and then select the corresponding movies --
-- ===================================================================================================================--

SELECT 
    f.title
FROM film f
WHERE f.film_id IN (                     -- with the subquery we go to rental table to use the DATEDIFF condition
    SELECT i.film_id FROM inventory i
    WHERE i.inventory_id IN (
        SELECT r.inventory_id
        FROM rental r
        WHERE DATEDIFF(r.return_date, r.rental_date) > 5 -- the oldest date always comes always first, in this case (return - rental)
    )
);


-- ===================================================================================================================================--
-- 23. Find the first and last name of the actors who have NOT acted in any film in the "Horror" category                             --
--     Use a subquery to find actors who have acted in movies in the "Horror" category and then exclude them from the list of actors. --                                                             --
-- ===================================================================================================================================--

SELECT 
    a.first_name, 
    a.last_name
FROM actor a
WHERE a.actor_id NOT IN ( 
    SELECT fa.actor_id FROM film_actor fa
    INNER JOIN film_category fc 
    ON fa.film_id = fc.film_id  -- matching the tables film_actor and film_category
    INNER JOIN category c 
    ON fc.category_id = c.category_id -- and now we can reach category table to set the condition 
    WHERE c.name = 'Horror'
);


/******************
* BONUS EXERCISES *
 ******************/

-- =============================================================================================================================--
-- 24. Find the title of films that are comedies and have a duration greater than 180 minutes in the film table with subqueries --
-- =============================================================================================================================--

SELECT 
f.title,
f.length 
FROM film f
WHERE f.length > 180 AND f.film_id IN (  
	SELECT f.film_id FROM film_category fc
    WHERE fc.category_id = (
		SELECT fc.category_id FROM category c
        WHERE c.name = 'Comedy'
        )
	);


-- ========================================================================================================================--
-- 25. Find all the actors who have acted together in at least one film.                                                  --
--     The query must show the first and last name of the actors and the number of films in which they have acted together --                                                             --
-- ========================================================================================================================--

SELECT
CONCAT(a1.first_name, ' ', a1.last_name) AS Actor_Name, -- using an "alias" we can join a table with itself
CONCAT(a2.first_name, ' ', a2.last_name) AS Actor2_Name, 
COUNT(fa1.film_id) AS Movies_Together
FROM actor a1
INNER JOIN film_actor fa1   -- with the next two joins we will connect actor 1 and 2 with the id of the movie., where we will check if they collaborated or not
ON a1.actor_id = fa1.actor_id
INNER JOIN film_actor fa2 
ON fa1.film_id = fa2.film_id 
INNER JOIN actor a2 
ON fa2.actor_id = a2.actor_id 
WHERE a1.actor_id < a2.actor_id -- here we are indicating that they are different so that it is not repeated, we could also use "!=" but the result will be more accurate with "<"
GROUP BY a1.actor_id, a2.actor_id 
HAVING COUNT(fa1.film_id) > 0; -- setting the "at least one film" condition 


/***************************** THANK YOU FOR CHECKING OUT ******************************/
