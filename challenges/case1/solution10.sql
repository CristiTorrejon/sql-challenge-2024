select
  p.nif, p.name, p.id
from culprit c
  inner join person p on p.id = c.person_id
except
select
  p.nif, p.name, p.id
from victim v
  inner join person p on p.id = v.person_id;