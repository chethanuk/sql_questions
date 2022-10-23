CREATE TABLE IF NOT EXISTS players
(
    player_id int,
    group_id  int
);
TRUNCATE TABLE players;
insert into players
values (15, 1);
insert into players
values (25, 1);
insert into players
values (30, 1);
insert into players
values (45, 1);
insert into players
values (10, 2);
insert into players
values (35, 2);
insert into players
values (50, 2);
insert into players
values (20, 3);
insert into players
values (40, 3);

CREATE TABLE IF NOT EXISTS matches
(
    match_id      int,
    first_player  int,
    second_player int,
    first_score   int,
    second_score  int
);
TRUNCATE TABLE matches;
insert into matches
values (1, 15, 45, 3, 0);
insert into matches
values (2, 30, 25, 1, 2);
insert into matches
values (3, 30, 15, 2, 0);
insert into matches
values (4, 40, 20, 5, 2);
insert into matches
values (5, 35, 50, 1, 1);

SELECT *
FROM players;

/**

  From above table get following output

  | first_player | first_score | first_player_gid | rnk |
| :--- | :--- | :--- | :--- |
| 15 | 3 | 1 | 1 |
| 35 | 1 | 2 | 1 |
| 40 | 5 | 3 | 1 |

 */

WITH temp as
         (SELECT m.match_id,
                 m.first_player,
                 m.second_player,
                 m.first_score,
                 m.second_score,
                 p.group_id  as first_player_gid,
                 p1.group_id as second_player_gid
          FROM matches m
                   LEFT JOIN players p on m.first_player = p.player_id
                   LEFT JOIN players p1 on m.second_player = p1.player_id),
     all_players_scores AS (SELECT first_player, first_score, first_player_gid
                            FROM temp
                            UNION ALL
                            SELECT second_player, second_score, second_player_gid
                            FROM temp)
# RANK to find top player
SELECT *
FROM (SELECT *,
             # IF Score is same then decide based on player ID
             DENSE_RANK() over (PARTITION BY first_player_gid ORDER BY first_score DESC, first_player) as rnk
      FROM all_players_scores) all_rank
WHERE rnk = 1;