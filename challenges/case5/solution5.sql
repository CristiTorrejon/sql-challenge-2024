WITH
  crime_details as (
    select
      cr.id,
      cr.location_id,
      array_agg(distinct v.person_id) victims,
      array_agg(distinct crki.item_id) key_items
    from crime cr
      left join victim v on v.crime_id = cr.id
      left join crime_key_item crki on crki.crime_id = cr.id
    where cr.name = 'Kidnapping in the city'
    group by cr.id
  ),
  detailed_person_overview as (
    select
      p.id,
      (count(distinct c.crime_id) > 0) has_criminal_record,
      coalesce(co.is_active, false) belongs_to_active_criminal_organization,
      array_agg(distinct fl.location_id) frequent_locations,
      array_agg(distinct oi.item_id) owned_items,
      array_agg(distinct (
        case
          when r.person_id = p.id then r.other_person_id
          else r.person_id
        end
      )) acquaintances
    from person p
      left join culprit c on c.person_id = p.id
      left join criminal_organization co on co.id = p.criminal_organization_id
      left join frequent_location fl on fl.person_id = p.id
      left join owned_item oi on oi.person_id = p.id
      left join relationship r on (r.person_id = p.id or r.other_person_id = p.id)
    group by
      p.id, co.is_active
  )
select
  p.nif,
  p.name,
  p.age,
  p.gender,
  (
    -- a. They know the victim
    (case when dpo.acquaintances @> cr.victims then 1 else 0 end)
    -- b. Frequents place where crime took place
    + (case when cr.location_id = any(dpo.frequent_locations) then 1 else 0 end)
    -- c. Has previous criminal record
    + (case when dpo.has_criminal_record then 1 else 0 end)
    -- d. Has agressive personality
    + (case when 'aggressive' = any(p.personality_traits) then 1 else 0 end)
    -- e. Has an height of 1.70 or higher
    + (case when (p.physical_attributes->>'height')::INT > 170 then 1 else 0 end)
    -- f. Owns at least one of the items found in the crime scene
    + (case when dpo.owned_items && cr.key_items then 1 else 0 end)
    -- g. Belongs to an active criminal organization
    + (case when dpo.belongs_to_active_criminal_organization then 1 else 0 end)
  ) as score,
  co.name criminal_organization,
  -- Display individual criteria to debug
  (dpo.acquaintances @> cr.victims) knows_victim,
  (cr.location_id = any(dpo.frequent_locations)) frequents_crime_location,
  dpo.has_criminal_record,
  ('aggressive' = any(p.personality_traits)) is_aggressive,
  ((p.physical_attributes->>'height')::INT > 170) is_tall,
  (dpo.owned_items && cr.key_items) owns_crime_item,
  dpo.belongs_to_active_criminal_organization
from crime_details cr, detailed_person_overview dpo
  inner join person p on p.id = dpo.id
  left join criminal_organization co on co.id = p.criminal_organization_id
order by
  score desc
limit 10;