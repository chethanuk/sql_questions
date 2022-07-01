create table customer_orders
(
    order_id     integer,
    customer_id  integer,
    order_date   date,
    order_amount integer
);
select *
from customer_orders;
insert into customer_orders
values (1, 100, cast('2022-01-01' as date), 2000)
     , (2, 200, cast('2022-01-01' as date), 2500)
     , (3, 300, cast('2022-01-01' as date), 2100)
     , (4, 100, cast('2022-01-02' as date), 2000)
     , (5, 400, cast('2022-01-02' as date), 2200)
     , (6, 500, cast('2022-01-02' as date), 2700)
     , (7, 100, cast('2022-01-03' as date), 3000)
     , (8, 400, cast('2022-01-03' as date), 1000)
     , (9, 600, cast('2022-01-03' as date), 3000);
SELECT *
FROM customer_orders;

/*
From customer_orders table get the following output

| order_date | new_customers | old_customer |
| :--- | :--- | :--- |
| 2022-01-03 | 1 | 2 |
| 2022-01-02 | 2 | 1 |
| 2022-01-01 | 3 | 0 |

 */

# SOLUTION USING IF INSTEAD OF CASE
WITH customer_first_date AS (SELECT customer_id,
                                    MIN(order_date) as first_order_date
                             FROM customer_orders
                             GROUP BY customer_id
                             ORDER BY customer_id)
SELECT order_date,
       SUM(IF(order_date = cfd.first_order_date, 1, 0)) as new_customers,
       SUM(IF(order_date != cfd.first_order_date, 1, 0)) as old_customer
FROM customer_orders as co
         LEFT JOIN customer_first_date as cfd
                   ON co.customer_id = cfd.customer_id
GROUP BY order_date;


/*
Include Customers order total
| order_date | new_customers | old_customer | new_customers_sum | old_customer_sum |
| :--- | :--- | :--- | :--- | :--- |
| 2022-01-01 | 3 | 0 | 6600 | 0 |
| 2022-01-02 | 2 | 1 | 4900 | 2000 |
| 2022-01-03 | 1 | 2 | 3000 | 4000 |
 */
# SOLUTION with Order Sum
WITH customer_first_date AS (SELECT customer_id,
                                    MIN(order_date) as first_order_date
                             FROM customer_orders
                             GROUP BY customer_id
                             ORDER BY customer_id)
SELECT order_date,
       SUM(CASE WHEN order_date = cfd.first_order_date THEN 1 ELSE 0 END) as new_customers,
       SUM(CASE WHEN order_date != cfd.first_order_date THEN 1 ELSE 0 END) as old_customer,
       SUM(CASE WHEN order_date = cfd.first_order_date THEN order_amount ELSE 0 END) as new_customers_sum,
       SUM(CASE WHEN order_date != cfd.first_order_date THEN order_amount ELSE 0 END) as old_customer_sum
FROM customer_orders as co
         LEFT JOIN customer_first_date as cfd
                   ON co.customer_id = cfd.customer_id
GROUP BY order_date
ORDER BY order_date;
