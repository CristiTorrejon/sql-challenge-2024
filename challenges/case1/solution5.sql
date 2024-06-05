WITH culprits_but_not_victims AS (
  SELECT DISTINCT c.person_id
  FROM culprit c
  LEFT OUTER JOIN victim v ON c.person_id = v.person_id
  WHERE v.person_id IS NULL
)
SELECT p.name, p.nif FROM person p
RIGHT JOIN culprits_but_not_victims cbnv ON cbnv.person_id = p.id;