WITH the_crime AS (
  SELECT
  c.id AS crime_id,
  v.person_id AS victim_id,
  c.location_id AS location_id
  FROM crime c
  LEFT JOIN victim v ON c.id = v.crime_id
  WHERE name = 'Kidnapping in the city'
),
knows_the_victim AS (
  SELECT c2.person_id
  FROM relationship r
  JOIN culprit c2 ON (c2.person_id = r.person_id OR c2.person_id = r.other_person_id )
  JOIN the_crime tc ON (tc.victim_id = r.person_id OR tc.victim_id = r.other_person_id )
),
frequents_the_location AS (
  SELECT p.id AS person_id
  FROM person p
  JOIN frequent_location fl ON p.id = fl.person_id
  JOIN the_crime tc ON fl.location_id = tc.location_id
),
criminals AS (
  SELECT c.person_id AS person_id
  FROM culprit c
),
aggressive_people AS (
  SELECT p.id AS person_id
  FROM person p
  WHERE 'aggressive' = any(p.personality_traits)
),
taller_than_170_people AS (
  SELECT p.id AS person_id
  FROM person p
  WHERE (p.physical_attributes->>'height')::integer >= 170
),
owns_objects_from_crime_scene AS (
  SELECT oi.person_id AS person_id
  FROM crime_key_item cki
  JOIN owned_item oi ON cki.item_id = oi.item_id
  JOIN the_crime tc ON tc.crime_id = cki.crime_id
),
belongs_to_org AS (
  SELECT p.id AS person_id
  FROM person p
  LEFT JOIN criminal_organization co ON co.id = p.criminal_organization_id
  WHERE co.is_active IS TRUE
),
mid_value AS (
  SELECT p.id ,
  CASE WHEN ktv.person_id IS NOT NULL THEN 1 ELSE 0 END AS ktv_value,
  CASE WHEN ftl.person_id IS NOT NULL THEN 1 ELSE 0 END AS ftl_value,
  CASE WHEN cs.person_id IS NOT NULL THEN 1 ELSE 0 END AS cs_value,
  CASE WHEN ap.person_id IS NOT NULL THEN 1 ELSE 0 END AS ap_value,
  CASE WHEN tt170.person_id IS NOT NULL THEN 1 ELSE 0 END AS tt170_value,
  CASE WHEN oofcs.person_id IS NOT NULL THEN 1 ELSE 0 END AS oofcs_value,
  CASE WHEN bto.person_id IS NOT NULL THEN 1 ELSE 0 END AS bto_value
  FROM person p
  LEFT JOIN knows_the_victim ktv ON p.id = ktv.person_id
  LEFT JOIN frequents_the_location ftl ON p.id = ftl.person_id
  LEFT JOIN criminals cs ON p.id = cs.person_id
  LEFT JOIN aggressive_people ap ON p.id = ap.person_id
  LEFT JOIN taller_than_170_people tt170 ON p.id = tt170.person_id
  LEFT JOIN owns_objects_from_crime_scene oofcs ON p.id = oofcs.person_id
  LEFT JOIN belongs_to_org bto ON p.id = bto.person_id
)
SELECT p2.id, p2.nif, p2."name", corg."name", (ktv_value + ftl_value + cs_value + ap_value + tt170_value + oofcs_value + bto_value) AS suspicious_level
FROM person p2
LEFT JOIN mid_value mv ON p2.id = mv.id
LEFT JOIN criminal_organization corg ON p2.criminal_organization_id = corg.id
ORDER BY (ktv_value + ftl_value + cs_value + ap_value + tt170_value + oofcs_value + bto_value) DESC
LIMIT 10