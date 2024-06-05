SELECT c."type" AS "crime_type", round(avg(p.age)) AS average_age
FROM crime c
LEFT JOIN culprit c2 ON c.id = c2.crime_id
LEFT JOIN person p ON p.id = c2.person_id
GROUP BY c."type";