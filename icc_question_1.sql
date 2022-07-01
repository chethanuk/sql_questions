show databases;
use interview;
DROP TABLE if exists icc_world_cup;
create table if not exists icc_world_cup
(
    Team_1 Varchar(20),
    Team_2 Varchar(20),
    Winner Varchar(20)
);
INSERT INTO icc_world_cup
values ('India', 'SL', 'India');
INSERT INTO icc_world_cup
values ('SL', 'Aus', 'Aus');
INSERT INTO icc_world_cup
values ('SA', 'Eng', 'Eng');
INSERT INTO icc_world_cup
values ('Eng', 'NZ', 'NZ');
INSERT INTO icc_world_cup
values ('Aus', 'India', 'India');
select *
from icc_world_cup;
/*
Question from icc_world_cup Table get following output:

| team | num_matches | total_wins | total_loss |
| :--- | :--- | :--- | :--- |
| Eng | 2 | 1 | 1 |
| SL | 2 | 0 | 2 |
| NZ | 1 | 1 | 0 |
| SA | 1 | 0 | 1 |
| Aus | 2 | 1 | 1 |
| India | 2 | 2 | 0 |
 */

# Solution 1:
WITH temp AS (SELECT Team_1,
                     CASE WHEN Team_1 = Winner THEN 1 else 0 end as won,
                     CASE WHEN Team_1 = Winner THEN 0 else 1 end as lost
              FROM icc_world_cup
              UNION all
              SELECT Team_2,
                     CASE WHEN Team_2 = Winner THEN 1 else 0 end as won,
                     CASE WHEN Team_2 = Winner THEN 0 else 1 end as lost
              FROM icc_world_cup)
SELECT Team_1        as team,
       count(Team_1) as num_matches,
       sum(won)      as total_wins,
       sum(lost)     as total_loss
FROM temp
GROUP BY Team_1
ORDER BY total_wins DESC;

# Solution 2:
select Team_1,
       count(1)                as no_of_matches_played,
       sum(winflag)            as no_of_matches_won,
       count(1) - sum(winflag) as no_of_losses
from (select Team_1, CASE when Team_1 = Winner then 1 else 0 end as winflag
      from icc_world_cup
      union all
      select Team_2, CASE when Team_2 = Winner then 1 else 0 end as winflag
      from icc_world_cup) A
group by Team_1
order by no_of_matches_won desc;

# DRAW Use case
INSERT INTO icc_world_cup
values ('Aus', 'India', 'Draw');
INSERT INTO icc_world_cup
values ('Eng', 'NZ', 'Draw');


with cte as (select *
             from icc_world_cup t1
             union
             select team_2, team_1, winner
             from icc_world_cup t2)
select distinct(team_1)                                                                Team_name
              , count(team_2)                                                          Matches_play
              , sum(case when winner = team_1 then 1 else 0 end)                       win
              , sum(case when winner <> team_1 and winner <> 'Draw' then 1 else 0 end) lose
              , sum(case when winner = 'Draw' then 1 else 0 end)                       draw
from cte
group by team_1;