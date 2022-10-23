CREATE TABLE IF NOT EXISTS users
(
    user_id        int,
    join_date      date,
    favorite_brand varchar(50)
);
TRUNCATE TABLE users;
CREATE TABLE IF NOT EXISTS orders
(
    order_id   int,
    order_date date,
    item_id    int,
    buyer_id   int,
    seller_id  int
);
TRUNCATE TABLE orders;
CREATE TABLE IF NOT EXISTS items
(
    item_id    int,
    item_brand varchar(50)
);
TRUNCATE TABLE items;

insert into users
values (1, '2019-01-01', 'Lenovo'),
       (2, '2019-02-09', 'Samsung'),
       (3, '2019-01-19', 'LG'),
       (4, '2019-05-21', 'HP');

insert into items
values (1, 'Samsung'),
       (2, 'Lenovo'),
       (3, 'LG'),
       (4, 'HP');

insert into orders
values (1, '2019-08-01', 4, 1, 2)
     , (2, '2019-08-02', 2, 1, 3)
     , (3, '2019-08-03', 3, 2, 3)
     , (4, '2019-08-04', 1, 4, 2)
     , (5, '2019-08-04', 1, 3, 4)
     , (6, '2019-08-05', 2, 2, 4);

/*
 For each seller whether brand of second item (by date) they sold is favourite or not
 If Seller has not sold more than two products then use O/P
 */


WITH second_fav AS
         (SELECT seller_id,
                 CASE WHEN item_brand = favorite_brand THEN 'YES' ELSE 'NO' END AS is_fav_sold
          FROM (SELECT *,
                       RANK() over (PARTITION BY seller_id ORDER BY order_date) as seller_rank
                FROM orders) o
                   JOIN items i on o.item_id = i.item_id

                   JOIN users u on o.seller_id = u.user_id
          WHERE seller_rank = 2)
SELECT user_id as seller_id, IFNULL(is_fav_sold, 'O/P') as is_fav_sold
FROM users u
         LEFT JOIN second_fav s on u.user_id = s.seller_id
;


# SOLUTION JUST USING LEFT JOIN
SELECT user_id,
                 CASE WHEN item_brand = favorite_brand THEN 'YES' ELSE 'NO' END AS is_fav_sold
          FROM users u
                LEFT JOIN (SELECT *,
                       RANK() over (PARTITION BY seller_id ORDER BY order_date) as seller_rank
                FROM orders) o
                    on o.seller_id = u.user_id
                   LEFT JOIN items i on o.item_id = i.item_id
          WHERE seller_rank = 2;

select seller_id, case when item_brand = favorite_brand then 'yes' else 'no' end as fav
FROM(
select * , row_number() over (partition by seller_id order by order_date asc) as rn from orders
  )a
  inner join items i on a.item_id = i.item_id
  left outer join users u on a.seller_id = u.user_id
  where rn =2
  UNION
  select u.user_id as seller_id,'no' from users u left outer join orders o on u.user_id = o.seller_id
  group by u.user_id
  having count(1) <2