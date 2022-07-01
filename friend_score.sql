/*
 Query to find PersonID, name, number of friends, sum of marks of person
 who have friends with total score greater than 100

| PersonID | Name | no_of_friends | total_friendScore | friends_names |
| :--- | :--- | :--- | :--- | :--- |
| 2 | Bob | 2 | 115 | Alice,Davis |
| 4 | Tara | 3 | 101 | Bob,Davis,John |

 */
with cte as (select f.PersonID,
                    p.Name,
                    count(f.FriendID)        no_of_friends,
                    sum(p1.Score)            total_friendScore,
                    group_concat(p1.Name) as friends_names
             from person p
                      join friend f on p.PersonID = f.PersonID
                      join person p1 on p1.PersonID = f.FriendID
             group by f.PersonID, p.Name)
select *
from cte
where total_friendScore >= 100;

# Solution 2
WITH p_score AS
         (SELECT f.FriendID, f.personid, score as p_score
          FROM friend f
                   LEFT JOIN person p on f.PersonID = p.PersonID),
     both_scores AS (SELECT p_score.PersonID, FriendID, p_score, score as f_score
                     FROM p_score
                              LEFT JOIN person p on p_score.FriendID = p.PersonID)
SELECT *,
       p_score + f_score as total
FROM both_scores
HAVING total >= 100;


# SOLUTION 2
with table1 as
         (select FriendID, PersonID
          from (select PersonID, FriendID, count(*) over ( partition by x.sum_of) as sum_of
                from (select PersonID, FriendID, sum_of = PersonID + FriendID
                      from friend) x) y
          where y.sum_of = 1),
     table2 as
         (select *
          from friend
          union
          select *
          from table1),
     table3 as
         (select T1.PersonID, T1.Name, T2.FriendID, T1.score
          from person T1
                   join table2 T2
                        on T1.PersonID = T2.PersonID),
     table4 as
         (select distinct T1.PersonID, T1.Name, T1.FriendID, T2.score
          from table3 T1
                   left join table3 T2
                             on T1.FriendID = T2.PersonID)
select PersonID, Name, number_of_friends, sum_score
from (select PersonID, Name, count(*) as number_of_friends, sum(score) as sum_score
      from table4
      group by PersonID, Name) x
where x.sum_score > 100;



with cte as (select f.PersonID
                  , p.Name
                  , count(f.FriendID) no_of_friends
                  , sum(p1.Score)     total_friendScore
             from person p
                      join friend f on p.PersonID = f.PersonID
                      join person p1 on p1.PersonID = f.FriendID
             group by f.PersonID, p.Name)
select *
from cte
where total_friendScore >= 100