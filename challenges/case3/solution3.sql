SELECT CR.type, COUNT(*)
FROM crime CR
JOIN culprit CU ON CR.id = CU.crime_id
WHERE CU.person_id IN (
  SELECT id
  FROM person
  WHERE gender = 'Male'
    AND physical_attributes ->> 'hairColor' = 'pink'
    AND physical_attributes ->> 'skinColor' = 'brown'
    AND age BETWEEN 20 AND 40
    AND 'analytical' = ANY(personality_traits)
  )
GROUP BY CR.type
ORDER BY 2 DESC
LIMIT 5