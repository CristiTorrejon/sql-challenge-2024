select distinct person.nif, person.name
from culprit
join person on culprit.person_id = person.id
where person_id not in (
select person_id
from victim);