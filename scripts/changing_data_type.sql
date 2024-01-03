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