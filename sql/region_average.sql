SELECT EXTRACT(WEEK FROM datetime), COUNT(1)
FROM jobsitytrips.refined_trips
WHERE region = '{}'
GROUP BY EXTRACT(WEEK FROM datetime)