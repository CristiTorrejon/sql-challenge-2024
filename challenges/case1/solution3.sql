select p.name, p.nif
from person p
inner join culprit c on p.id = c.person_id
where p.id not in (select person_id from victim)
group by p.id
order by p.id;