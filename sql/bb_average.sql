SELECT EXTRACT(WEEK FROM datetime), COUNT(1)
FROM jobsitytrips.refined_trips
WHERE ST_COVERS(
    ST_GEOGFROMTEXT('POLYGON(({} {}, {} {}, {} {}, {} {}, {} {}))'), 
    destination_coord
  )
GROUP BY EXTRACT(WEEK FROM datetime);