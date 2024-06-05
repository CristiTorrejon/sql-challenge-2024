select cr.type as CrimeType, count(*) as NoOfCrimes
from postgres.public.person p inner join postgres.public.culprit culp on p.id = culp.person_id
inner join postgres.public.crime cr on cr.id = culp.crime_id
where p.gender = 'Male'
and p.physical_attributes->>'hairColor' = 'pink'
and p.physical_attributes->>'skinColor' = 'brown'
and p.age >= 20 and p.age <= 40
and 'analytical' = ANY (p.personality_traits)
group by cr.type
order by count(*) desc
limit 5
