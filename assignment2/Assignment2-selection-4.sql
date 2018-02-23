#1 Find all films with maximum length or minimum rental duration (compared to all other films). 
#In other words let L be the maximum film length, and let R be the minimum rental duration in the table film. You need to find all films that have length L or duration R or both length L and duration R.
#You just need to return attribute film id for this query. 

SELECT film_id FROM film WHERE length = (SELECT max(length) FROM film) OR rental_duration = (SELECT min(rental_duration) FROM film);

#2 We want to find out how many of each category of film ED CHASE has started in so return a table with category.name and the count
#of the number of films that ED was in which were in that category order by the category name ascending (Your query should return every category even if ED has been in no films in that category).

-- number of times ed was in a movie of each category
SELECT C.name, COUNT(A.actor_id) AS filmsEdWasIn
FROM category C
LEFT JOIN film_category FC ON C.category_id=FC.category_id 
LEFT JOIN film F ON F.film_id=FC.film_id
LEFT JOIN film_actor FA ON F.film_id=FA.film_id
LEFT JOIN actor A ON FA.actor_id=A.actor_id AND A.actor_id=3
GROUP BY C.category_id
ORDER BY C.name;

#3 Find the first name, last name and total combined film length of Sci-Fi films for every actor
#That is the result should list the names of all of the actors(even if an actor has not been in any Sci-Fi films)and the total length of Sci-Fi films they have been in.

SELECT A.first_name, A.last_name, SUM(F.length) AS combinedFilmLength
FROM category C
INNER JOIN film_category FC ON FC.category_id=C.category_id and C.name = 'Sci-Fi'
INNER JOIN film F on F.film_id=FC.film_id
INNER JOIN film_actor FA ON F.film_id = FA.film_id
RIGHT JOIN actor A ON A.actor_id = FA.actor_id
GROUP BY A.actor_id
ORDER BY A.first_name, A.last_name;

#4 Find the first name and last name of all actors who have never been in a Sci-Fi film
SELECT A.first_name, A.last_name
FROM actor A
WHERE A.actor_id NOT IN
(SELECT A2.actor_id FROM actor A2 
	INNER JOIN film_actor FA ON FA.actor_id=A2.actor_id
	INNER JOIN film F ON F.film_id=FA.film_id
	INNER JOIN film_category FC ON F.film_id=FC.film_id
	INNER JOIN category C ON FC.category_id=C.category_id
	WHERE C.name="Sci-Fi");

#5 Find the film title of all films which feature both KIRSTEN PALTROW and WARREN NOLTE
#Order the results by title, descending (use ORDER BY title DESC at the end of the query)
#Warning, this is a tricky one and while the syntax is all things you know, you have to think oustide
#the box a bit to figure out how to get a table that shows pairs of actors in movies

SELECT L1.title 
FROM (SELECT F1.title, A1.first_name, A1.last_name 
    FROM actor A1 INNER JOIN film_actor FA1 ON A1.actor_id = FA1.actor_id
    INNER JOIN film F1 ON FA1.film_id = F1.film_id
    WHERE A1.first_name = 'KIRSTEN' AND A1.last_name='PALTROW') as L1
INNER JOIN (SELECT F2.title, A2.first_name, A2.last_name 
    FROM actor A2 INNER JOIN film_actor FA2 ON A2.actor_id = FA2.actor_id
    INNER JOIN film F2 ON FA2.film_id = F2.film_id
    WHERE A2.first_name = 'WARREN' AND A2.last_name='NOLTE') as L2
ON L1.title = L2.title
ORDER BY L1.title DESC;