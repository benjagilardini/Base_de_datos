/*CLASE 14*/
1) 
/*Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.*/
SELECT CONCAT_WS(' ',c.first_name, c.last_name) as 'name', a.address, ci.city
    FROM customer c
    INNER JOIN address a ON c.address_id = a.address_id
    INNER JOIN city ci ON a.city_id = ci.city_id
    INNER JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';

2)
/*Write a query that shows the film title, language and rating. 
Rating shall be shown as the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.*/
SELECT title,
`language`.name, 
CASE
    WHEN rating = 'G' THEN 'All Ages Are Admitted.'
    WHEN rating = 'PG' THEN 'Some Material May Not Be Suitable For Children.'
    WHEN rating = 'PG-13' THEN 'Some Material May Be Inappropriate For Children Under 13.'
    WHEN rating = 'R' THEN 'Under 17 Requires Accompanying Parent Or Adult Guardian.'
    WHEN rating = 'NC-17' THEN 'No One 17 and Under Admitted.'
END AS rating_description
  FROM film
    INNER JOIN `language` USING (language_id);
   
 3)
 /*Write a search query that shows all the films (title and release year) an actor was part of. 
Assume the actor comes from a text box introduced by hand from a web page. 
Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.*/
 
 SELECT f.title, f.release_year, CONCAT_WS(' ',a.first_name, a.last_name) as actores
 FROM film f
 INNER JOIN film_actor fa ON fa.film_id = f.film_id
 INNER JOIN actor a ON a.actor_id = fa.actor_id
 WHERE CONCAT_WS(' ', a.first_name, a.last_name) LIKE TRIM(UPPER(' PeNELope guiNESs'));

 
 4)
 /*Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. 
 There should be returned column with two possible values 'Yes' and 'No'.*/
 
 SELECT DISTINCT f.title, c.last_name, 
 CASE
  WHEN r.return_date is not NULL THEN 'yes'
  WHEN r.return_date is NULL THEN 'no'
END AS returned
 FROM film f
 INNER JOIN inventory i ON i.film_id = f.film_id
 INNER JOIN rental r ON r.inventory_id = i.inventory_id
 INNER JOIN customer c ON c.customer_id = r.customer_id
WHERE MONTH(r.rental_date) BETWEEN 5 AND 6;

5)
/*Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.*/
 SELECT CAST(last_update AS DATE) AS only_date FROM rental;

SELECT CONVERT("2006-02-15", DATETIME);
6)
/*Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.*/
 SELECT rental_id, IFNULL(return_date, 'La pelicula no fue devuelta aun') as 'fecha_de_devolucion'
	FROM rental
	WHERE rental_id = 1261
	OR rental_id = 12611;

-- ISNULL() function returns 1 if the expression passed is NULL, otherwise it returns 0.

SELECT rental_id, ISNULL(return_date) as pelicula_faltante
	FROM rental
	WHERE rental_id = 12610
	OR rental_id = 12611;

-- COALESCE() function returns the first non-NULL argument of the passed list.

SELECT COALESCE (
	NULL,
	NULL,
	(SELECT return_date
		FROM rental
		WHERE rental_id = 12610), -- null date
    (SELECT return_date
        FROM rental
        WHERE rental_id = 12611)
) as primer_valor_no_nulo;
