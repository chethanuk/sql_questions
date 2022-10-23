CREATE TABLE IF NOT EXISTS movie_seats
(
    seat      varchar(50),
    occupancy int
);
TRUNCATE TABLE movie_seats;
insert into movie_seats
values ('a1', 1),
       ('a2', 1),
       ('a3', 0),
       ('a4', 0),
       ('a5', 0),
       ('a6', 0),
       ('a7', 1),
       ('a8', 1),
       ('a9', 0),
       ('a10', 0),
       ('b1', 0),
       ('b2', 0),
       ('b3', 0),
       ('b4', 1),
       ('b5', 1),
       ('b6', 1),
       ('b7', 1),
       ('b8', 0),
       ('b9', 0),
       ('b10', 0),
       ('c1', 0),
       ('c2', 1),
       ('c3', 0),
       ('c4', 1),
       ('c5', 1),
       ('c6', 0),
       ('c7', 1),
       ('c8', 0),
       ('c9', 0),
       ('c10', 1);
SELECT *
FROM movie_seats;


SELECT *,
       DENSE_RANK() over (partition by r_name ORDER BY r_no ASC ) as r1
FROM (SELECT *,
             SUBSTRING(seat, 1, 1)                     as r_name,
             CAST(SUBSTRING(seat, 2, 2) AS DECIMAL(0)) AS r_no
      FROM movie_seats) as seats
WHERE occupancy = 0;

# SOLUTION 1

# SOLUTION 2
with cte as
         (select *
               , case
                     when sum(case when occupancy = 0 then 1 else 0 end)
                              over (partition by left(seat, 1) rows between 3 preceding and current row) = 4
                         then 'true'
                     when sum(case when occupancy = 0 then 1 else 0 end)
                              over (partition by left(seat, 1) rows between 2 preceding and 1 following) = 4
                         then 'true'
                     when sum(case when occupancy = 0 then 1 else 0 end)
                              over (partition by left(seat, 1) rows between 1 preceding and 2 following) = 4
                         then 'true'
                     when sum(case when occupancy = 0 then 1 else 0 end)
                              over (partition by left(seat, 1) rows between current row and 3 following) = 4
                         then 'true' end flag
          from movie_seats)
select *
from cte
where flag = 'true';

WITH CTE AS
    (SELECT *, SUBSTRING(seat, 1, 1) as rn, CAST(SUBSTRING(seat, 2, 2) AS DECIMAL) as seq FROM movie_seats)
   , CTE1 AS (SELECT *, seq - ROW_NUMBER() OVER (PARTITION BY rn ORDER BY seq ASC) as diff FROM CTE WHERE occupancy = 0)
   , CTE2 AS (SELECT *, COUNT(*) OVER (PARTITION BY diff,rn ORDER BY diff) as cnt FROM CTE1)
SELECT *
FROM CTE2
WHERE CNT >= 4;

# SOLUTION WITH JOINS
WITH base_empty_seats AS (
    SELECT *,
       MAX(occupancy) OVER (PARTITION BY r_name ORDER BY r_no ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING) as is_4_empty,
       COUNT(occupancy) OVER (PARTITION BY r_name ORDER BY r_no ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING) as total_seats
FROM (SELECT *,
             SUBSTRING(seat, 1, 1) as r_name,
             CAST(SUBSTRING(seat, 2, 2) AS DECIMAL(0)) AS r_no
      FROM movie_seats) as seats
)
SELECT *
FROM base_empty_seats B1
         INNER JOIN (SELECT * FROM base_empty_seats WHERE is_4_empty = 0 AND total_seats >= 4) B2
                    ON B1.r_name = B2.r_name AND B1.occupancy = B2.occupancy
                        AND B1.r_no BETWEEN B2.r_no and B2.r_no + 3;