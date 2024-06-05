WITH total_culprits AS (
SELECT DISTINCT person_id FROM culprit c
),
persons_of_interest AS (
  SELECT c.person_id, 'culprit' AS crime_role, c2.incident_date FROM culprit c LEFT JOIN crime c2 ON c.crime_id = c2.id
  UNION
  SELECT v.person_id, 'victim' AS crime_role, c2.incident_date FROM victim v LEFT JOIN crime c2 ON v.crime_id = c2.id
),
first_incidents AS (
  SELECT
  person_id,
  min(CASE WHEN crime_role = 'victim' THEN incident_date ELSE NULL END) AS first_incident_date_victim,
  min(CASE WHEN crime_role = 'culprit' THEN incident_date ELSE NULL END) AS first_incident_date_culprit
  FROM persons_of_interest
  GROUP BY person_id
),
persons_both_incidents AS (
  SELECT *
  FROM first_incidents
  WHERE first_incident_date_victim IS NOT NULL
  AND first_incident_date_culprit IS NOT NULL
),
victims_then_culprits AS (
  SELECT * FROM persons_both_incidents
  WHERE first_incident_date_victim < first_incident_date_culprit
),
culprits_then_victims AS (
  SELECT * FROM persons_both_incidents
  WHERE first_incident_date_victim > first_incident_date_culprit
)
SELECT
(SELECT count(*) FROM total_culprits) AS total_culprits,
(SELECT count(*) FROM victims_then_culprits) AS victims_then_culprits,
(SELECT count(*) FROM culprits_then_victims) AS culprits_then_victims;
