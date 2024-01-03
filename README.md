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
