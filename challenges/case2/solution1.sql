select c.type, floor(avg(p.age))::int as Average_Age
from public.crime c
inner join public.culprit cu on c.id = cu.crime_id
inner join public.person p on cu.person_id = p.id
group by c.type