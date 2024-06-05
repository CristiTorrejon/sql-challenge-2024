SELECT DISTINCT p.nif, p.name
FROM person p
INNER JOIN culprit cu ON p.id = cu.person_id
WHERE NOT EXISTS (
  SELECT 1
  FROM victim v
  WHERE p.id = v.person_id
);