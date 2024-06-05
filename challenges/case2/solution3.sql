SELECT CR.type, ROUND(AVG(P.age)) "Average Age"
FROM culprit CU
JOIN (SELECT id, type FROM crime) CR ON CU.crime_id = CR.id
JOIN (SELECT id, age FROM person) P ON CU.person_id = P.Id
GROUP BY CR.type