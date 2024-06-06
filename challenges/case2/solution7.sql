select
  cr.type crime_type,
  avg(p.age) avg_culprit_age
from culprit c
  inner join person p on p.id = c.person_id
  inner join crime cr on cr.id = c.crime_id
group by cr.type