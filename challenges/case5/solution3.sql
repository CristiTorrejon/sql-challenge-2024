with crime_data as (
  -- Crime data (crime_id = 122, victim_id = 4160, crime_location_id = 498)
  select c.id as crime_id, v.person_id as victim_id, l.id as crime_location_id
  from victim v, crime c, location l
  where c."name" = 'Kidnapping in the city' and c.id = v.crime_id and c.location_id = l.id
),
crime_item_owners as (
  -- array of people that are owners of the crime items [122,1001,1002] => [379,2627,2950,4318,6051,7284,8848,50004]
  select array_agg(p.id) as owners
  from person p
  left join owned_item oi on oi.person_id = p.id
  left join item i on i.id = oi.item_id
  left join crime_key_item cki on cki.item_id = i.id
  where cki.crime_id = (select crime_id from crime_data)
),
crime_location_visitors as (
  -- array of people that have been in the crime location => [379,4318]
  select array_agg(p.id) as visitors
  from person p
  left join frequent_location fl on fl.person_id = p.id
  where fl.location_id = (select crime_location_id from crime_data)
),
victim_acquaintances as (
  -- array of people that know the victim [379,4318,6051,50004]
  select array_agg(p.id) as acquaintances
  from person p , relationship r
  where (r.person_id = p.id and r.other_person_id = (select victim_id from crime_data))
  or (r.person_id = (select victim_id from crime_data) and r.other_person_id = p.id)
  and p.id !=(select victim_id from crime_data)
),
criminal_record as (
  -- array of people with criminal records
  select array_agg(p.id) as criminals
  from person p
  left join culprit c on c.person_id = p.id
)
select
p.nif, p.name,
sum(
  case
    when p.id = any(select unnest(acquaintances) from victim_acquaintances) = true then 1 else 0
  end +
  case
    when p.id = any(select unnest(visitors) from crime_location_visitors) = true then 1 else 0
  end +
  case
    when p.id = any (select unnest(criminals) from criminal_record) = true then 1 else 0
  end +
  case
    when (p.personality_traits @> '{"aggressive"}') = true then 1 else 0
  end +
  case
    when (p.physical_attributes->>'height')::int >= 170 then 1 else 0
  end +
  case
    when p.id = any(select unnest(owners) from crime_item_owners) = true then 1 else 0
  end +
  case
    when co.is_active = true then 1 else 0
  end
  ) as score,
co."name" as criminal_organization_name
from person p
left join criminal_organization co on co.id = p.criminal_organization_id
group by p.id, p.nif, p.name, co.name
order by score desc
limit 10
