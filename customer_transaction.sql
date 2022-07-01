DROP TABLE IF EXISTS transactions;
create table IF NOT EXISTS transactions
(
    cus_id     varchar(20),
    txn_date   date,
    txn_amount int
);
insert into transactions
values ('P1', '2022-03-01', 500),
       ('P1', '2022-03-01', 900),
       ('P1', '2022-03-02', 500),
       ('P1', '2022-03-02', 500),
       ('P1', '2022-03-02', 900),
       ('P1', '2022-03-02', 500),
       ('P4', '2022-03-01', 600);
SELECT *
FROM transactions;

/*
 For given transaction table,
 For which customer and transaction date, total or cumulative amount become more than 2000
 */

# Total cumulative
WITH temp as
         (SELECT *,
                 sum(txn_amount) OVER (PARTITION BY cus_id ORDER BY txn_date) as cum_amt
          FROM transactions)
SELECT cus_id,
       # Can use rank as well and filter by rank = 1
#        rank() over (partition by cus_id order by cum_amt)
       min(txn_date) as first_over_date
from temp
where cum_amt >= 2000
GROUP BY cus_id;

# Cumulative per day
WITH temp as
         (SELECT *,
                 sum(txn_amount) OVER (PARTITION BY cus_id, txn_date ORDER BY txn_date) as cum_amt
          FROM transactions)
SELECT *
from temp
where cum_amt >= 2000;
