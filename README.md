# F1 race results 2023
Practicing PostgreSQL using f1 data 

## Uploading and transforming the data
[2023 Race Results](Formula1_2023season_raceResults.csv)

1. [Renaming the columns](scripts/f1_race_results_rename_columns.sql)
![image](https://github.com/HannaStselmashok/f1_fun/assets/99286647/3f7b25da-c615-429e-854c-c80d444c6ffb)

2. [Changing data type](scripts/changing_data_type.sql) to integer for position column (replace NC / DQ with 20)
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

