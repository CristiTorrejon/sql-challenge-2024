select distinct per.nif, per.name
from postgres.public.person per
inner join postgres.public.culprit culp on culp.person_id = per.id
where not(exists(select 1 from postgres.public.victim v where v.person_id = per.id))