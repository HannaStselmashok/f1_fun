# F1 race results 2023
Practicing PostgreSQL using f1 data 

## Uploading and transforming the data
Table 1 [2023 Race Results](Formula1_2023season_raceResults.csv)

1. [Renaming the columns](scripts/f1_race_results_rename_columns.sql)

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/3f7b25da-c615-429e-854c-c80d444c6ffb)

2. [Changing data type](scripts/changing_data_type.sql) to integer for position column (replace NC / DQ with 20)

Table 2 [races order](races_order_2023.csv)

## Fun queries
1. [Find](scripts/first_driver_ratio.sql) the average position of every racer during the championship; total points, the share of points contributed by the team's lead driver

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/4dddf925-cf97-4def-91fa-4add6d64f8f6)

2. [Calculate](scripts/driver_in_championship.sql) a driver's championship points for each race; a driver's position in the championship for each race.

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/f14f5209-6389-4dc3-b16c-83894e36cb02)

3. [Display](scripts/change_of_position.sql) the rating of drivers based on the frequency of position changes in the championship.

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/14ebca0e-853e-403f-a4ee-516b5fb02b6d)

4. For each race, [display](scripts/fastest_lap_time.sql) the driver who took the best lap

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/f591949c-a9c1-46f7-bdf1-1883182a82f5)

6. Find the racers with the most intense battle during the championship

![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/de90056e-7855-439e-ba62-9ec809392b9d)
![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/029672e7-160c-45ac-b80f-0d63ba524a98)
