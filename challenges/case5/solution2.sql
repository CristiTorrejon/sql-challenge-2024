--Initially we get the crime info to makes things easier later
with CrimeInfo (crime_id, victim_id, location_id) as (
  select c.id,
  v.person_id,
  c.location_id
  from public.crime c inner join public.victim v on c.id = v.crime_id
  where c.name = 'Kidnapping in the city')
,
-- Adding people info (excluding the victim)
-- +1 for knowing the victim
KnowsVictimPoints (id, nif, name, criminal_organization, points) as (
  select p.id,
  p.nif,
  p.name,
  co.name,
  case when exists(
  select 1
  from public.relationship r inner join CrimeInfo ci
  on (r.person_id = ci.victim_id and r.other_person_id = p.id)
  or (r.person_id = p.id and r.other_person_id = ci.victim_id)) then 1
  else 0 end
  from public.person p left outer join public.criminal_organization co on p.criminal_organization_id = co.id
  where p.id not in (select victim_id from CrimeInfo)),
-- +1 if person frequents the location
FrequentsLocationAccPoints (id, nif, name, criminal_organization, points) as (
  select p.id,
  p.nif,
  p.name,
  p.criminal_organization,
  p.Points + case when exists(
    select 1
    from public.frequent_location fl inner join CrimeInfo ci on fl.location_id = ci.location_id
    where fl.person_id = p.id) then 1
    else 0 end
    from KnowsVictimPoints p),
-- +1 if person has been a culprit of a crime
CulpritAccPoints (id, nif, name, criminal_organization, points) as (
  select p.id,
  p.nif,
  p.name,
  p.criminal_organization,
  p.Points + case when exists(
    select 1
    from public.culprit c
    where c.person_id = p.id) then 1 else 0 end
    from FrequentsLocationAccPoints p),
-- +1 if person has a aggressive personality
AggressivePersonalityAccPoints (id, nif, name, criminal_organization, points) as (
  select p.id,
  p.nif,
  p.name,
  p.criminal_organization,
  p.Points + case when 'aggressive'=any(p2.personality_traits) then 1 else 0 end
  from CulpritAccPoints p inner join public.person p2 on p.id = p2.id),
-- +1 if height > 170
HeightAccPoints (id, nif, name, criminal_organization, points) as (
  select p.id,
  p.nif,
  p.name,
  p.criminal_organization,
  p.Points + case when cast(p2.physical_attributes->>'height' as integer)>=170 then 1 else 0 end
  from AggressivePersonalityAccPoints p inner join public.person p2
  on p.id = p2.id),
-- +1 if person owns objects
OwnedObjectsAccPoints (id, nif, name, criminal_organization, points) as (
  select p.id,
  p.nif,
  p.name,
  p.criminal_organization,
  p.Points + case when exists(
    select 1
    from public.crime_key_item cki inner join CrimeInfo ci on cki.crime_id = ci.crime_id
    inner join public.owned_item oi on oi.item_id = cki.item_id
    where oi.person_id = p.id
    ) then 1
    else 0 end
    from HeightAccPoints p),
-- +1 if he belongs to an active criminal organization
ActiveCriminalOrgAccPoints (id, nif, name, criminal_organization, points) as (
  select p.id,
  p.nif,
  p.name,
  p.criminal_organization,
  p.Points + case when co.id is not null then 1
    else 0 end
    from OwnedObjectsAccPoints p left outer join public.person p2 on p.id = p2.id
    left outer join public.criminal_organization co on co.id = p2.criminal_organization_id and co.is_active is true)
select nif, name, points, criminal_organization
from ActiveCriminalOrgAccPoints
order by points desc
limit 10