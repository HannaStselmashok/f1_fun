WITH drivers_sum_points as (

    SELECT 
        round as no_race,
        track_country,
        driver_name, 
        sum(points)
        over (
            partition by driver_name
            order by round
            ) as sum_points
    FROM
        formula1_data 
    LEFT JOIN 
        races_order 
        on lower(formula1_data.track_country) = replace(races_order.grand_prix_id, '-', ' ') 
    GROUP BY 
        round,
        track_country,
        driver_name,
        points

), drivers_in_championship as (
    
    SELECT 
        no_race,
        track_country,
        driver_name,
        sum_points,
        dense_rank()
        over (
            partition by no_race 
            order by sum_points desc
            ) as driver_in_championship
    FROM
        drivers_sum_points
    ORDER BY 
        no_race,
        driver_name
)

SELECT 
    *
FROM 
    drivers_in_championship
--WHERE 
--    driver_name = 'Carlos Sainz'
ORDER BY 
    no_race