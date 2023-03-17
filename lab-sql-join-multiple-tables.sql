USE sakila;

# 1. Write a query to display for each store its store ID, city, and country.
# use tables store, address, city, country
SELECT store_id
FROM store;

SELECT S.store_id, C.city, CO.country # show store, id, city, and country columns
FROM store AS S  
JOIN address AS A ON S.address_id = A.address_id # join store and address using the common column address_id
JOIN city AS C ON A.city_id = C.city_id
JOIN country AS CO ON C.country_id = CO.country_id; # join city and country using the common column country_id


# 2. Write a query to display how much business, in dollars, each store brought in.
#use tables store, customer, payment

SELECT S.store_id, ROUND(SUM(P.amount)) AS amount_in_dollars # show the store_id, and the amount that has been added up and rounded of to no decimals, and show it as amount_in_dollars
FROM store AS S
JOIN customer AS CU ON S.store_id = CU.store_id #join store and customer using the common column store_id
JOIN payment AS P ON CU.customer_id = P.customer_id # join payment to the previous join using customer_id
GROUP BY S.store_id # group by store_id as we want to see how much each store brought in
ORDER BY amount_in_dollars DESC; # order amounts in descending order so it's cleaner


# 3. What is the average running time of films by category?
#use tables film
SELECT title, ROUND(AVG(length)) AS avg_length # show the title of the film and the average length of the film, rounded off with no decimals, as avg_length
FROM film
GROUP BY title # group by title as we want to see the average length of the titles
ORDER BY avg_length DESC; # order in a descending way, as it's cleaner



# 4. Which film categories are longest?
# use tables film, film_category, category
SELECT C.name, ROUND(AVG(F.length)) AS avg_length # show the name of the category and the average length per category, rouded off with no decimals,as avg_length
FROM film AS F
JOIN film_category AS FC ON F.film_id = FC.film_id # join film and film_category on the common column film_id
JOIN category AS C ON FC.category_id = C.category_id # join category and film_category on the common column category_id
GROUP BY C.name # group by name as we want to see the names of the film categories 
ORDER BY avg_length DESC; # order in descending way as it's cleaner


# 5. Display the most frequently rented movies in descending order.
# use tables film, inventory, rental
SELECT F.title, COUNT(rental_id) AS times_rented # show the titles of the films, count the rental ids (assuming it means the number of times a film was rented) and show it as times_rented
FROM film AS F
JOIN inventory AS I ON F.film_id = I.film_id # join film and inventory on common column film_id
JOIN rental as R ON I.inventory_id = R.inventory_id
GROUP BY F.title # group by title as we are looking for the names of the most frequently rented films
ORDER BY times_rented DESC; # order in descending way as it's cleaner

# 6. List the top five genres in gross revenue in descending order.
# use tables category, film_category, film, inventory, rental, payment
SELECT CA.name, ROUND(SUM(P.amount), 0) AS gross_revenue # show the name of the genre, and the added up amount that was paid, rounded off with no decimals, as gross_revenue
FROM category AS CA
JOIN film_category AS FC ON CA.category_id = FC.category_id # join category and film_category on common column category_id
JOIN film AS F ON FC.film_id = F.film_id # join film on common column film_id
JOIN inventory AS I ON F.film_id = I.film_id # join inventory on common column film_id
JOIN rental AS R ON I.inventory_id = R.inventory_id # join rental on common column inventory_id
JOIN payment AS P ON R.rental_id = P.rental_id # join payment on common column rental_id
GROUP BY CA.name # group by name as we want to know the genres 
ORDER BY gross_revenue DESC # order in descending way as we're looking for the top 5
LIMIT 5; # limit to 5 as we're looking for the top 5
### I joined the tables based on the connections in the ERD, but is it necessary to go through all of these tables or skip stright to joining just film_id and skipping a table?


# 7. Is "Academy Dinosaur" available for rent from Store 1?
#use tables film, inventory, store

SELECT *
FROM film
WHERE title = 'Academy Dinosaur'; # we now know that the film_id of Academy Dinosaur is 1

SELECT *
FROM inventory
WHERE film_id = 1; 

SELECT F.title, S.store_id, COUNT(*) AS available_films # show the title of the film, the store_id, and count the number of available films as available_films
FROM store AS S
INNER JOIN inventory AS I ON S.store_id = I.store_id # join store and inventory on the common column store_id
INNER JOIN film AS F ON F.film_id = I.film_id # join film on the common column inventory_id
LEFT JOIN rental AS R ON I.inventory_id = R.inventory_id AND R.return_date IS NULL # left join rental on the common column inventory_id and incorporate the null values as null means the film hasn't been returned yet
WHERE F.title = 'Academy Dinosaur'  # only look for the title 'Academy Dinosaur'
AND S.store_id = 1 # only look for store_id 1
AND R.rental_id IS NULL; # look for where the rental_id is null 
