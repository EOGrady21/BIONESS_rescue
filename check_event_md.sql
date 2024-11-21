SELECT
    biochem.bcmissions.name,
    biochem.bcevents.collector_station_name,
    biochem.bcevents.collector_event_id,
    biochem.bcevents.min_lat,
    biochem.bcevents.max_lat,
    biochem.bcevents.min_lon,
    biochem.bcevents.max_lon
FROM
         biochem.bcevents
    INNER JOIN biochem.bcmissions ON biochem.bcmissions.mission_seq = biochem.bcevents.mission_seq
WHERE
    biochem.bcmissions.name = 'cruisename'