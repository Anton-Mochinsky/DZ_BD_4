SELECT name, year FROM alboms
WHERE year = 2018;

SELECT name, duration FROM tracks
ORDER BY duration DESC
LIMIT 1;

SELECT name , duration FROM tracks
WHERE duration >= 210;

SELECT name FROM collections
WHERE year >=2018 AND year <=2020;

SELECT name FROM singers
WHERE name NOT LIKE '% %'


SELECT name FROM tracks
WHERE name LIKE '%my%'

--количество исполнителей в каждом жанре
SELECT genre_id, COUNT(singer_id) FROM genressingers g 
GROUP BY genre_id 
ORDER BY COUNT(singer_id) DESC;

--количество треков, вошедших в альбомы 2019-2020 годов
SELECT t.name, COUNT(DISTINCT t.id) FROM tracks t 
JOIN alboms a ON t.id = a.id
WHERE year BETWEEN 2019 AND 2020
GROUP BY t.name;

--средняя продолжительность треков по каждому альбому
SELECT AVG(duration), a.name FROM tracks t 
JOIN alboms a ON a.id = t.id
GROUP BY a.name;

--все исполнители, которые не выпустили альбомы в 2020 году
SELECT s.name FROM singers s 
JOIN alboms a ON s.id = a.id
WHERE year != 2020
GROUP BY s.name;

--названия сборников, в которых присутствует конкретный исполнитель (выберите сами)
SELECT c.name FROM collections as c 
INNER JOIN collectionstracks as c2 ON c2.collection_id = c.id 
INNER JOIN tracks as t ON t.id = c2.track_id 
INNER JOIN albomssingers as a ON a.albom_id = t.albom_id 
INNER JOIN singers as s ON t.albom_id = a.singer_id  
WHERE s.name = 'Певец';

--название альбомов, в которых присутствуют исполнители более 1 жанра
SELECT a.name FROM alboms a
INNER JOIN albomssingers a2 ON a2.albom_id = a.id 
INNER JOIN genressingers g ON g.singer_id  = a2.singer_id  
GROUP BY a.id 
HAVING COUNT(g.genre_id) > 1;

--наименование треков, которые не входят в сборники
SELECT t.name FROM tracks t 
LEFT JOIN collectionstracks c ON c.track_id = t.id 
WHERE c.collection_id IS NULL;

--исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько)

SELECT DISTINCT s.name FROM tracks t 
INNER JOIN albomssingers a ON a.albom_id = t.albom_id 
INNER JOIN singers s ON s.id = a.singer_id  
WHERE t.duration = (SELECT MIN(duration) FROM tracks);

-- название альбомов, содержащих наименьшее количество треков.
SELECT a.name FROM alboms as a 
LEFT JOIN tracks as t ON t.albom_id = a.id 
GROUP BY a.id 
HAVING COUNT(t.id) = (SELECT MIN(t.c) FROM (SELECT a.id, COUNT(t.id) as c FROM alboms as a 
LEFT JOIN tracks as t ON t.albom_id = a.id 
GROUP BY a.id) as t);

