SELECT c."type", COUNT(*) AS number_of_crimes
FROM crime c
LEFT JOIN culprit c2 ON c2.crime_id = c.id
LEFT JOIN person p ON p.id = c2.person_id
WHERE p.gender = 'Male'
AND p.physical_attributes ->> 'hairColor' = 'pink'
AND p.physical_attributes ->> 'skinColor' = 'brown'
AND 'analytical' = ANY (p.personality_traits)
AND p.age BETWEEN 20 AND 40
GROUP BY c."type"
ORDER BY 2 DESC