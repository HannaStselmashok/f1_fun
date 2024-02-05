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

2. [Calculate](scripts/driver_in_championship.sql) a driver's championship points for each race; a driver's position in the championship for each race.

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/f14f5209-6389-4dc3-b16c-83894e36cb02)

3. [Display](scripts/change_of_position.sql) the rating of drivers based on the frequency of position changes in the championship.

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/14ebca0e-853e-403f-a4ee-516b5fb02b6d)

4. For each race, [display](scripts/fastest_lap_time.sql) the driver who took the best lap

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/f591949c-a9c1-46f7-bdf1-1883182a82f5)

6. [Find](scripts/sweaty_rank.sql) the racers with the most intense battle during the championship

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/de90056e-7855-439e-ba62-9ec809392b9d)
![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/029672e7-160c-45ac-b80f-0d63ba524a98)
