WITH drivers_sum_points as (

    SELECT 
        round as no_race,
        track_country,
        driver_name, 
        sum(points) over (partition by driver_name order by round) as sum_points
    FROM    
        formula1_data
    INNER JOIN
        races_order 
        on lower(formula1_data.track_country) = replace(races_order.grand_prix_id, '-', ' ') 
    GROUP BY 
        round,
        track_country,
        driver_name,
        points

), dif_points as (

    SELECT 
        dsp1.no_race,
        dsp1.track_country,
        dsp1.driver_name as driver_name_1,
        dsp2.driver_name as driver_name_2,
        abs(dsp1.sum_points - dsp2.sum_points) as difference_points
    FROM
        drivers_sum_points as dsp1
    INNER JOIN 
        drivers_sum_points as dsp2
        on dsp1.track_country = dsp2.track_country
        and dsp1.driver_name <> dsp2.driver_name
        and dsp1.driver_name < dsp2.driver_name
        
)

SELECT 
    driver_name_1,
    driver_name_2,
    round(avg(difference_points),2) as sweaty_avg,
    row_number() 
    over(
        order by round(avg(difference_points),2)) as sweaty_rank
FROM
    dif_points
GROUP BY 
    1, 2
ORDER BY 
    3 