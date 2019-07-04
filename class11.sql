1)
-- Find all the film titles that are not in the inventory. 
SELECT title FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL;

2)
--Find all the films that are in the inventory but were never rented. 
--Show title and inventory_id.
-- This exercise is complicated. 
-- hint: use sub-queries in FROM and in WHERE or use left join and ask if one of the fields is null

SELECT f.title, i.inventory_id 
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
LEFT JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

3)
-- Generate a report with:
-- customer (first, last) name, store id, film title, 
-- when the film was rented and returned for each of these customers
-- order by store_id, customer last_name
S
ELECT r.rental_date, r.return_date,c.first_name, c.last_name, f.title, s.store_id
FROM film f
INNER JOIN inventory i 
USING (film_id)
INNER JOIN store s 
USING (store_id)
INNER JOIN customer c
USING (store_id)
INNER JOIN rental r
USING (customer_id)
WHERE r.rental_date IS NOT NULL
ORDER BY s.store_id, c.last_name;

4)
--Show sales per store (money of rented films)
--show store's city, country, manager info and total sales (money)
--(optional) Use concat to show city and country and manager first and last name

SELECT CONCAT(c.city, ', ', co.country) AS store,
CONCAT(m.first_name, ' ', m.last_name) AS manager,
SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN store AS s ON i.store_id = s.store_id
INNER JOIN address AS a ON s.address_id = a.address_id
INNER JOIN city AS c ON a.city_id = c.city_id
INNER JOIN country AS co ON c.country_id = co.country_id
INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
GROUP BY s.store_id
ORDER BY co.country, c.city;

5)
-- Which actor has appeared in the most films?

SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(actor_id) AS film_count
FROM actor
INNER JOIN film_actor USING (actor_id)
GROUP BY actor_id, actor.first_name, actor.last_name
HAVING COUNT(actor_id) >= (SELECT COUNT(film_id)
FROM film_actor
GROUP BY actor_id
ORDER BY 1 DESC
LIMIT 1)
ORDER BY film_count DESC;


