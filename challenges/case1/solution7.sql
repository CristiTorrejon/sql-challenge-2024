SELECT DISTINCT p.nif, p.name
FROM person p
INNER JOIN culprit cu ON p.id = cu.person_id
LEFT JOIN victim v ON p.id = v.person_id
WHERE v.person_id IS NULL;