SELECT name, nif
FROM person
WHERE id IN (SELECT person_id FROM culprit)
AND id NOT IN (SELECT person_id FROM victim);