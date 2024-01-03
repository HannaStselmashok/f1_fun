SELECT 
    round asno_race,
    track_country,
    driver_name,
    fastest_lap_time 
FROM
    formula1_data
INNER JOIN 
    races_order
    on lower(formula1_data.track_country) = replace(races_order.grand_prix_id, '-', ' ') 
WHERE
    has_set_fastest_lap = 'Yes'
ORDER BY 
    1