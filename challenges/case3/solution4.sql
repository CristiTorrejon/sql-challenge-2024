select cr."type" as "crime type", count(*) as "number of crimes"
from person p, culprit c, crime cr
where p.gender = 'Male'
and p.physical_attributes->>'hairColor' LIKE '%pink%'
and p.physical_attributes->>'skinColor' LIKE '%brown%'
and p.age between 20 and 40
and p.personality_traits @> '{"analytical"}'
and p.id = c.person_id
and c.crime_id = cr.id
group by cr."type"
order by "number of crimes" desc
limit 5