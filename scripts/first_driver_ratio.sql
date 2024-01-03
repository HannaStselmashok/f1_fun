WITH drivers_ranked as (

    SELECT 
        team_name,
        driver_name,
        avg(
            case 
                when position ~ '^\d+$'
                then cast(position as integer)
                else 20
            end
        ) as average_position,
        sum(points) as sum_points,
        row_number()
        over (
            partition by team_name 
            order by sum(points) desc
            ) as row_number_drivers
    FROM 
        formula1_data
    GROUP BY 
        1, 2
    
), drivers_ranked_main as (

    SELECT 
        team_name,  
        driver_name,
        round(average_position, 2) as average_position,
        sum_points,
        row_number_drivers
    FROM
        drivers_ranked
    WHERE 
        row_number_drivers <= 2
    ORDER BY 
        1, 4 desc
        
)

SELECT 
    team_name,
    driver_name,
    average_position,
    sum_points,
    case 
        when row_number_drivers = 1
        then round(sum_points / sum(sum_points)
            over (partition by team_name) * 100, 2)
        else null 
    end as first_driver_ratio
FROM
    drivers_ranked_main