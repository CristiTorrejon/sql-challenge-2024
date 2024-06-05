select distinct crime.type, round(avg(person.age))
from culprit
join person on culprit.person_id = person.id
join crime on culprit.crime_id = crime.id
group by crime.type