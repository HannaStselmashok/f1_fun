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