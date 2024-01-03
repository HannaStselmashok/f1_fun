WITH drivers_sum_points as (

    SELECT 
        round as no_race,
        track_country,
        driver_name, 
        sum(points)
        over (
            partition by driver_name 
            order by round) as sum_points
    FROM    
        formula1_data
    INNER JOIN 
        races_order on lower(formula1_data.track_country) = replace(races_order.grand_prix_id, '-', ' ') 
    GROUP BY 
        round,
        track_country,
        driver_name,
        points

), driver_place_in_champoinship as (

    SELECT 
        no_race,
        track_country,
        driver_name,
        sum_points,
        dense_rank() 
        over (
            partition by no_race 
            order by sum_points desc) as driver_in_championship
    FROM drivers_sum_points
    ORDER BY 
        no_race,
        driver_name

), driver_place_in_champoinship_rank as (

    SELECT 
        no_race,
        track_country,
        driver_name,
        sum_points,
        driver_in_championship,
        case   
            when driver_in_championship = lag(driver_in_championship, 1) 
            over (
                partition by driver_name 
                order by no_race)
            then 0
            else 1
        end as change_position_count
    FROM 
        driver_place_in_champoinship
    ORDER BY 
        3, 1
    
)

SELECT 
    driver_name,
    sum(change_position_count) as change_of_position
FROM 
    driver_place_in_champoinship_rank
GROUP BY 
    driver_name
ORDER BY 
    2 DESC