select
  cr.type,
  count(distinct cr.id) num_of_incidences
from crime cr
  inner join culprit c on c.crime_id = cr.id
  inner join person p on p.id = c.person_id
where
  p.gender = 'Male'
  and p.physical_attributes->>'hairColor' = 'pink'
  and p.physical_attributes->>'skinColor' = 'brown'
  and 'analytical' = any(p.personality_traits)
  and p.age between 20 and 40
group by
  cr."type"
order by
  count(distinct cr.id) desc
limit 5;
