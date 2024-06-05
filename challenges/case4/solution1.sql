WITH victims_criminals AS (
  SELECT p.id, min_victim_date, min_criminal_date
  FROM person P
  LEFT JOIN (SELECT person_id, MIN(C.incident_date) min_victim_date
  FROM victim V
  JOIN crime C ON V.crime_id = C.id
  GROUP BY person_id) victims ON P.id = victims.person_id
  LEFT JOIN (SELECT person_id, MIN(C.incident_date) min_criminal_date
  FROM culprit CU
  JOIN crime C ON CU.crime_id = C.id
  GROUP BY person_id) criminals ON P.id = criminals.person_id
)
SELECT 'criminals' "Info", COUNT(min_criminal_date) "Count" FROM victims_criminals
UNION ALL
SELECT 'criminals after being victims' "Info", COUNT(*) "Count" FROM victims_criminals WHERE min_criminal_date > min_victim_date
UNION ALL
SELECT 'victims after being criminals' "Info", COUNT(*) "Count" FROM victims_criminals WHERE min_victim_date > min_criminal_date
