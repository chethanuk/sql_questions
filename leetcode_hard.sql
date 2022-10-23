CREATE TABLE IF NOT EXISTS Trips
(
    id         int,
    client_id  int,
    driver_id  int,
    city_id    int,
    status     varchar(50),
    request_at varchar(50)
);
CREATE TABLE IF NOT EXISTS Users
(
    users_id int,
    banned   varchar(50),
    role     varchar(50)
);
Truncate table Trips;
insert into Trips (id, client_id, driver_id, city_id, status, request_at)
values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at)
values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at)
values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at)
values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at)
values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at)
values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at)
values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at)
values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at)
values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at)
values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
Truncate table Users;
insert into Users (users_id, banned, role)
values ('1', 'No', 'client');
insert into Users (users_id, banned, role)
values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role)
values ('3', 'No', 'client');
insert into Users (users_id, banned, role)
values ('4', 'No', 'client');
insert into Users (users_id, banned, role)
values ('10', 'No', 'driver');
insert into Users (users_id, banned, role)
values ('11', 'No', 'driver');
insert into Users (users_id, banned, role)
values ('12', 'No', 'driver');
insert into Users (users_id, banned, role)
values ('13', 'No', 'driver');


/*
 Find cancellation rate of requests with unbanned users (both client and driver must not be banned)
 each day between 10-01 to 10-03

 cancellation rate = Number of cancelled requests / total requests
 */

SELECT *
FROM Trips;
SELECT *
FROM Users;

# SELECT id, client_id, driver_id, status, banned
WITH any_agent_banned AS
         (SELECT id,
                 client_id,
                 driver_id,
                 status,
                 U.banned  as                                                                         user_banned,
                 U2.banned as                                                                         driver_banned,
                 CASE WHEN U.banned = 'Yes' OR U2.banned = 'Yes' THEN TRUE ELSE FALSE END             any_banned,
                 request_at,
                 CASE WHEN status in ('cancelled_by_driver', 'cancelled_by_client') THEN 1 ELSE 0 END is_cancelled
          FROM Trips T
                   LEFT JOIN Users U on T.client_id = U.users_id
                   LEFT JOIN Users U2 on T.driver_id = U2.users_id)
# SELECT * FROM any_agent_banned;
SELECT request_at,
       sum(is_cancelled)                       as total_cancellations,
       count(is_cancelled)                     as total_rides,
       sum(is_cancelled) / count(is_cancelled) as cancellation_rate
FROM any_agent_banned
WHERE any_banned = 0
GROUP BY request_at;

