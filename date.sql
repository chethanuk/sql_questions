/*
Find nth occurrence of Sunday from given date

If 2022-01-01 is Saturday
Then 1st occurrence of Sunday is 2022-01-02
Then 2st occurrence of Sunday is 2022-01-09
 */

# SOLUTION 1 - Manual
WITH temp as
         (select '2022-01-02' as start_date,
                 3            as nth_occurrence),
     first_sunday AS (SELECT *,
                             DATE_ADD(@today_date, INTERVAL 1 day) as first_sunday
                      FROm temp)
SELECT *,
       # SOLUTION 1
       DATE_ADD(first_sunday, INTERVAL nth_occurrence WEEK) as nth_sunday
FROM first_sunday;

# SOLUTION 2 without Manually figuring out day
WITH temp as
         (select '2022-01-04' as start_date,
                 3            as nth_occurrence),
     first_week_day AS (SELECT *,
                               DATE_ADD(start_date, INTERVAL 8 - dayofweek(start_date) day) as first_sunday
                        FROM temp)
SELECT *,
       DATE_ADD(first_sunday, INTERVAL nth_occurrence - 1 week) as nth_sunday
FROM first_week_day;

# SOLUTION 3
SET @today_date = '2022-01-01'; -- Saturday
SET @n = 3;
SELECT DATE_ADD(DATE_ADD(@today_date, interval (8 - dayofweek(@today_date)) day), interval @n - 1 week) as nth_sunday;
