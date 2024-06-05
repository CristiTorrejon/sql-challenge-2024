select distinct p.name, p.nif
from culprit c
inner join person p on c.person_id = p.id
where not exists (
  select 1
  from
  victim v
where c.person_id = v.person_id);