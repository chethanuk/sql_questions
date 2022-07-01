create table entries
(
    name      varchar(20),
    address   varchar(20),
    email     varchar(20),
    floor     int,
    resources varchar(10)
);

insert into entries
values ('A', 'Bangalore', 'A@gmail.com', 1, 'CPU')
     , ('A', 'Bangalore', 'A1@gmail.com', 1, 'CPU')
     , ('A', 'Bangalore', 'A2@gmail.com', 2, 'DESKTOP')
     , ('B', 'Bangalore', 'B@gmail.com', 2, 'DESKTOP')
     , ('B', 'Bangalore', 'B1@gmail.com', 2, 'DESKTOP')
     , ('B', 'Bangalore', 'B2@gmail.com', 1, 'MONITOR');

SELECT *
FROM entries;
/*
From Above table
Find following answer:
| name | total_visits | resource_used | floor |
| :--- | :--- | :--- | :--- |
| A | 3 | CPU,DESKTOP | 1 |
| B | 3 | DESKTOP,MONITOR | 2 |

 */

# WITH floor_visits AS
#          (SELECT name,
#                  floor,
#                  count(1) as floor_visits
#           FROM entries
#           GROUP BY name, floor);

# SOLUTION 1
# NOTE: In Some SQL version, Use string_agg instead of group_concat
WITH floor_rank AS
         (SELECT floor_visits.*,
                 DENSE_RANK() over (partition by name ORDER BY floor_visits DESC) as drk
          FROM ((SELECT name,
                        floor,
                        count(1) as floor_visits
                 FROM entries
                 GROUP BY name, floor) AS floor_visits))
SELECT e.name,
       COUNT(e.name)                                           as total_visits,
       group_concat(DISTINCT resources ORDER BY resources ASC) as resource_used,
       f.floor
FROM entries as e
         JOIN floor_rank as f on f.name = e.name
WHERE f.drk = 1
GROUP BY e.name
ORDER BY e.name;

# SOLUTION 2
SELECT name,
       COUNT(email)                                                          AS total_visits,
       (SELECT floor
        FROM (SELECT floor, COUNT(1)
              FROM entries
              GROUP BY floor
              ORDER BY COUNT(1)
              LIMIT 1) AS t1)                                                AS most_visited_floor,
       GROUP_CONCAT(DISTINCT resources ORDER BY resources ASC SEPARATOR ',') AS resources_used
FROM entries
GROUP BY 1;

# SOLUTIN M
with above_table as (select name,
resources,
count(*) as count_resource
from entries
group by name, resources)

select name,
sum(count_resource),
group_concat(resources) as resources_list,
rank() over(order by name) as rank_name
from above_table
group by name;