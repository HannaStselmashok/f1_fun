# F1 race results 2023
Practicing PostgreSQL using f1 data 

## Uploading and transforming the data
Table 1 [2023 Race Results](Formula1_2023season_raceResults.csv)

1. Renaming the columns
```sql
ALTER TABLE public.formula1_data RENAME COLUMN "Track" TO track_country;
ALTER TABLE public.formula1_data RENAME COLUMN "Position" TO "position";
ALTER TABLE public.formula1_data RENAME COLUMN "No" TO driver_number;
ALTER TABLE public.formula1_data RENAME COLUMN "Driver" TO driver_name;
ALTER TABLE public.formula1_data RENAME COLUMN "Team" TO team_name;
ALTER TABLE public.formula1_data RENAME COLUMN "Starting Grid" TO starting_grid;
ALTER TABLE public.formula1_data RENAME COLUMN "Laps" TO laps;
ALTER TABLE public.formula1_data RENAME COLUMN "Time/Retired" TO finish_time_text;
ALTER TABLE public.formula1_data RENAME COLUMN "Points" TO points;
ALTER TABLE public.formula1_data RENAME COLUMN "Set Fastest Lap" TO has_set_fastest_lap;
ALTER TABLE public.formula1_data RENAME COLUMN "Fastest Lap Time" TO fastest_lap_time;

SELECT *
FROM formula1_data
LIMIT 5
```

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/3f7b25da-c615-429e-854c-c80d444c6ffb)

2. Changing data type to integer for position column (replace NC / DQ with 20)
```sql
--Expression ~ '^\d+$' check if the data in a cell is an integer number
--if it is - change data type to integer
--if it's not - replace the value with 20

SELECT 
    case 
        when position ~ '^\d+$'
        then cast(position as integer)
        else 20
    end as position
FROM 
    formula1_data
```

Table 2 [races order](races_order_2023.csv)

## Fun queries
1. Find the average position of every racer during the championship; total points, the share of points contributed by the team's lead driver

```sql
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
```

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/4dddf925-cf97-4def-91fa-4add6d64f8f6)

2. Calculate a driver's championship points for each race; a driver's position in the championship for each race.

```sql
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
```

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/f14f5209-6389-4dc3-b16c-83894e36cb02)

3. Display the rating of drivers based on the frequency of position changes in the championship.

```sql
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
```

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/14ebca0e-853e-403f-a4ee-516b5fb02b6d)

4. For each race, display the driver who took the best lap

```sql
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
```

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/f591949c-a9c1-46f7-bdf1-1883182a82f5)

5. Find the racers with the most intense battle during the championship

```sql
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
```

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/de90056e-7855-439e-ba62-9ec809392b9d)
![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/029672e7-160c-45ac-b80f-0d63ba524a98)
