SELECT c.type AS crime_type, ROUND(AVG(p.age)) AS average_age
FROM public.crime c
JOIN public.culprit cu ON c.id = cu.crime_id
JOIN public.person p ON cu.person_id = p.id
GROUP BY c.type;