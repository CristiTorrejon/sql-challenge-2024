SELECT DISTINCT p.name, p.nif
FROM public.person p
INNER JOIN culprit ON p.id = culprit.person_id
LEFT JOIN victim ON p.id = victim.person_id
where victim.person_id is null;