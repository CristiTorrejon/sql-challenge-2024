with unique_culprits as (
  select count(distinct(c.person_id)) as "number_of_culprits"
  from culprit c
  ),
crime_dates as (
  select p.id as person_id,
  min(crime_as_culprit.incident_date) as "crime_as_culprit_min_date",
  min(crime_as_victim.incident_date) as "crime_as_victim_min_date"
  from person p
  inner join victim v on v.person_id = p.id
  inner join culprit c on c.person_id = p.id
  inner join crime as crime_as_victim on crime_as_victim.id = v.crime_id
  inner join crime as crime_as_culprit on crime_as_culprit.id = c.crime_id
  group by p.id
)
select number_of_culprits as results
from unique_culprits
union
select count(distinct(person_id))
from crime_dates
where crime_as_culprit_min_date > crime_as_victim_min_date
union
select count(distinct(person_id))
from crime_dates
where crime_as_culprit_min_date < crime_as_victim_min_date