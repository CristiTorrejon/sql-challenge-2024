select cr.type as "crime type", ROUND(AVG(p.age)) "culprit average rounded age"
from crime cr, culprit cl, person p
where cr.id = cl.crime_id and cl.person_id = p.id
group by cr."type";