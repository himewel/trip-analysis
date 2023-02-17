SELECT region, datetime
FROM (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY region ORDER BY datetime) r
  FROM jobsitytrips.refined_trips
  ORDER BY r DESC
  LIMIT 2
)