with people_dates as (
select p.id,
  (select c.incident_date
  from public.victim v inner join public.crime c on v.crime_id = c.id
  where v.person_id = p.id
  order by c.incident_date
  limit 1) as FirstVictimWhen,
  (select c.incident_date
  from public.culprit culp inner join public.crime c on culp.crime_id = c.id
  where culp.person_id = p.id
  order by c.incident_date
  limit 1) as FirstCulpritWhen
  from public.person p)
select count(*)
from people_dates
where FirstCulpritWhen is not null
and FirstVictimWhen is not null
and FirstCulpritWhen < FirstVictimWhen