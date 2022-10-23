CREATE TABLE IF NOT EXISTS tasks
(
    date_value date,
    state      varchar(10)
);
TRUNCATE TABLE tasks;
insert into tasks
values ('2019-01-01', 'success')
     , ('2019-01-02', 'success')
     , ('2019-01-03', 'success')
     , ('2019-01-04', 'fail')
     , ('2019-01-05', 'fail')
     , ('2019-01-06', 'success');

# with all_dates as
#      (select *,
#              ROW_NUMBER() over (partition by state order by date_value) as rn,
#              ROW_NUMBER() over (partition by state order by date_value) * -1 as group_date
#       from tasks)
# select group_date, min(date_value) start_date, max(date_value) end_date, state
# from all_dates
# group by group_date, state
# order by start_date;

# SOLUTION 1
with all_dates as
     (select *,
             ROW_NUMBER() over (order by date_value) -
             ROW_NUMBER() over (partition by state order by date_value) differ
      from tasks)
select min(date_value) start_date, max(date_value) end_date, state, differ
from all_dates
group by state, differ
order by start_date, end_date;

# SOLUTION 2
with grp_data as
         (select *,
                 sum(lag1) over (order by date_value) as grp
          from (select *,
                       case when lag(state) over () = state then 0 else 1 end as lag1
                from tasks) a)
select state, min(date_value) as start_date, max(date_value) as end_date
from grp_data
group by state, grp
order by start_date;