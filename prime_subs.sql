CREATE TABLE IF NOT EXISTS prime_users
(
    user_id   integer,
    user_name varchar(20),
    join_date date
);
TRUNCATE TABLE prime_users;
insert into prime_users
values (1, 'Jon', CAST('2020-02-14' AS date)),
       (2, 'Jane', CAST('2020-02-14' AS date)),
       (3, 'Jill', CAST('2020-02-15' AS date)),
       (4, 'Josh', CAST('2020-02-15' AS date)),
       (5, 'Jean', CAST('2020-02-16' AS date)),
       (6, 'Justin', CAST('2020-02-17' AS date)),
       (7, 'Jeremy', CAST('2020-02-18' AS date));
SELECT *
FROM users;

CREATE TABLE IF NOT EXISTS events
(
    user_id     integer,
    type        varchar(10),
    access_date date
);
TRUNCATE TABLE events;
insert into events
values (1, 'Pay', CAST('2020-03-01' AS date)),
       (2, 'Music', CAST('2020-03-02' AS date)),
       (2, 'P', CAST('2020-03-12' AS date)),
       (3, 'Music', CAST('2020-03-15' AS date)),
       (4, 'Music', CAST('2020-03-15' AS date)),
       (1, 'P', CAST('2020-03-16' AS date)),
       (3, 'P', CAST('2020-03-22' AS date));;

SELECT *
FROM events;

/*
 Find rate of users who used Prime music and upgraded to Amazon Prime within 30 days of joining
 */

SELECT *,
    lag(access_date) OVER (partition by user_id order by access_date) as lag1
#     case when lag(access_date) over () = state then 0 else 1 end as lag1
FROM events WHERE type in ('Music', 'P')