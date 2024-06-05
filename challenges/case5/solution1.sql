WITH crime_info AS (SELECT id, location_id FROM crime WHERE name = 'Kidnapping in the city')
, active_orgs AS (SELECT id, name FROM criminal_organization WHERE is_active = 'true')
SELECT P.nif, P.name, scores.total_score, CO.name "criminal org"
FROM person P
LEFT JOIN active_orgs CO ON P.criminal_organization_id = CO.id
JOIN (
  -- Get Total Score for each Person
  SELECT id, SUM(score) "total_score" FROM
  (
  -- knows the victim
  SELECT person_id "id", 1 "score" FROM relationship WHERE other_person_id = (SELECT person_id FROM victim WHERE crime_id = (SELECT id FROM crime_info))
  UNION ALL
  -- frequents the crime scene
  SELECT person_id "id", 1 "score" FROM frequent_location WHERE location_id = (SELECT location_id FROM crime_info)
  UNION ALL
  -- has a criminal record
  SELECT id, 1 "score" FROM person WHERE id IN (SELECT DISTINCT person_id FROM culprit)
  UNION ALL
  -- has personality trait 'aggressive'
  SELECT id, 1 "score" FROM person WHERE 'aggressive' = ANY(personality_traits)
  UNION ALL
  -- has a height of at least 170cm
  SELECT id, 1 "score" FROM person WHERE CAST(physical_attributes->>'height' AS int) >= 170
  UNION ALL
  -- owns at least one of the items found at the crime scene
  SELECT OI.person_id "id", 1 "score" FROM crime_key_item CKI LEFT JOIN owned_item OI ON CKI.item_id = OI.item_id WHERE CKI.crime_id IN (SELECT id FROM crime_info)
  UNION ALL
  -- belongs to an active criminal organization
  SELECT id, 1 "score" FROM person WHERE criminal_organization_id IN (SELECT id FROM active_orgs)
  ) AS temp_scores
  GROUP BY id
) AS scores ON P.id = scores.id
ORDER BY 3 DESC
LIMIT 10