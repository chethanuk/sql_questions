DROP TABLE IF EXISTS products;
create table IF NOT EXISTS products
(
    product_id varchar(20),
    cost       int
);
insert into products
values ('P1', 200),
       ('P2', 300),
       ('P3', 500),
       ('P4', 800);
DROP TABLE IF EXISTS customer_budget;
create table IF NOT EXISTS customer_budget
(
    customer_id int,
    budget      int
);

insert into customer_budget
values (100, 400),
       (200, 800),
       (300, 1500);

SELECT *
FROM products;
SELECT *
FROM customer_budget;
/*
Question find how many Products fall into customer budget along with list of products
*/
WITH products_rcost AS (SELECT *,
                               # NOTE might need to do distinct to remove duplicate
                               sum(cost) OVER (ORDER BY cost) as running_cost
                        FROM products),
     temp as (SELECT *
              FROM customer_budget as c
                       cross join products_rcost as p
              WHERE p.running_cost <= c.budget
              ORDER BY customer_id)
SELECT customer_id,
       budget,
       count(product_id)                                     as no_of_products,
       group_concat(DISTINCT product_id ORDER BY product_id) as list_of_products
FROM temp
GROUP BY customer_id, budget;

/*
 Option 2
 Read more about ROWS BETWEEN https://learnsql.com/blog/sql-window-functions-rows-clause/
 */
with running_cost as
         (select *,
                 sum(cost) over (rows between unbounded preceding and current row) as running
          from products)
select customer_id,
       min(budget)                   as budget,
       count(*)                      as no_of_products,
       GROUP_CONCAT(product_id, ',') as list_of_products
from customer_budget c
         join running_cost p
              on p.running <= c.budget
group by customer_id
order by customer_id;

/*
 Option 3
 Problems: Nested query might take lot of time to parse
 */
Select c.customer_id,
       c.budget,
       group_concat(product_id, ',') as list_of_product
from (Select a.*,
             b.*,
             sum(cost)
                 over (partition by customer_id order by cost rows between unbounded preceding and current row) as rol_sum
      from customer_budget a
               join products b
                    on a.budget > b.cost) c
where c.budget > c.rol_sum
group by c.customer_id, c.budget;


# OPTION
with running_total as
         (select product_id, cost, sum(cost) over (order by product_id) as run from products)
select c.customer_id, c.budget, count(product_id) as no_of_products, group_concat(product_id) as list_products
from running_total r,
     customer_budget c
where c.budget > r.run
group by c.customer_id, c.budget;