1.
SELECT title
FROM movies
WHERE year = 2008;

2.
SELECT birth 
FROM people
WHERE name = 'Emma Stone';

3.
SELECT title 
FROM movies
WHERE year >= 2018
ORDER BY title ASC;

4.
SELECT COUNT(movie_id) 
FROM ratings
WHERE rating = 10;

5.
SELECT title, year 
FROM movies
WHERE title 
LIKE 'Harry Potter%'
ORDER BY year ASC;

6.
SELECT AVG(ratings.rating) 
FROM ratings
JOIN movies ON ratings.movie_id = movies.id
WHERE year = 2012;

7. 
SELECT movies.title, ratings.rating 
FROM movies
JOIN ratings ON movies.id = ratings.movie_id
WHERE movies.year = 2010
ORDER BY rating DESC, title ASC;

8.
SELECT people.name 
FROM people
JOIN stars ON people.id = stars.person_id
JOIN movies ON stars.movie_id = movies.id
WHERE movies.title = 'Toy Story';

9.
SELECT name
FROM people
WHERE id IN
(
    SELECT DISTINCT people.id
    FROM people
    JOIN stars ON people.id = stars.person_id
    JOIN movies ON stars.movie_id = movies.id
    WHERE movies.year = 2004
)
ORDER BY birth;

10.
SELECT name
FROM people
WHERE id IN
(
    SELECT DISTINCT people.id
    FROM people
    JOIN directors ON people.id = directors.person_id
    JOIN ratings ON directors.movie_id = ratings.movie_id
    WHERE ratings.rating >= 9
);

11.
SELECT movies.title FROM movies
JOIN stars ON movies.id = stars.movie_id
JOIN people ON stars.person_id = people.id
JOIN ratings ON movies.id = ratings.movie_id
WHERE people.name = 'Chadwick Boseman'
ORDER BY ratings.rating DESC
LIMIT 5;

12.
SELECT DISTINCT movies.title FROM movies
JOIN stars ON movies.id = stars.movie_id
WHERE movie_id IN
(
    SELECT movie_id FROM stars
    WHERE person_id =
    (
        SELECT DISTINCT id FROM people
        WHERE name = 'Johnny Depp'
    )
)
AND movie_id IN
(
    SELECT movie_id FROM stars
    WHERE person_id =
    (
        SELECT DISTINCT id FROM people
        WHERE name = 'Helena Bonham Carter'
    )
);

13.
SELECT DISTINCT people.name FROM people
JOIN stars ON people.id = stars.person_id
WHERE movie_id IN
(
    SELECT movie_id from stars
    WHERE person_id =
    (
        SELECT id FROM people
        WHERE name = 'Kevin Bacon'
        AND birth = 1958
    )
)
AND NOT people.name = 'Kevin Bacon';
