with
  culprit_first_crime_summary as (
    select
      c.person_id,
      min(ccr.incident_date) first_commited_crime_date,
      min(vcr.incident_date) first_crime_victim_date
    from culprit c
      inner join crime ccr on ccr.id = c.crime_id
      left join victim v on v.person_id = c.person_id
      left join crime vcr on vcr.id = v.crime_id
    group by c.person_id
  )
select
  count(cfcs.person_id) total_criminals,
  count(cfcs.person_id) filter (where cfcs.first_commited_crime_date > cfcs.first_crime_victim_date) total_turned_criminals,
  count(cfcs.person_id) filter (where cfcs.first_commited_crime_date < cfcs.first_crime_victim_date) total_victims_after_crime
from culprit_first_crime_summary cfcs