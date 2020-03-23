WITH Count_orders_and_common_sum_CTE (create_date, count_orders, sum_amount)
AS
(
select create_date, count(order_num) as count_orders, sum(total_amount) as sum_amount
from orders
group by create_date
),
Full_paid_orders_CTE (create_date, full_paid_orders)
AS
(
select create_date, count(*) as full_paid_orders from (
select orders.create_date as create_date, orders.order_num, orders.total_amount as sum_orders, sum(payments.amount) as sum_amount 
from orders
left join payments on orders.order_num = payments.order_num
group by orders.order_num
having sum_orders = sum_amount) as Full_paid_orders 
group by create_date
),
AVG_amount_CTE (create_date, avg_amount)
AS
(
select create_date, avg(sum_amount) as avg_amount from (
select orders.create_date as create_date, 
ifnull(sum(payments.amount), 0) as sum_amount
from orders
left join payments on orders.order_num = payments.order_num
group by orders.order_num) as AVG_amount
group by create_date
)
select 
Count_orders_and_common_sum_CTE.create_date as create_date,
Count_orders_and_common_sum_CTE.count_orders as count_orders,
Count_orders_and_common_sum_CTE.sum_amount as sum_amount,
Full_paid_orders_CTE.full_paid_orders as full_paid_orders,
AVG_amount_CTE.avg_amount as avg_amount
from Count_orders_and_common_sum_CTE
join Full_paid_orders_CTE on Count_orders_and_common_sum_CTE.create_date = Full_paid_orders_CTE.create_date
join AVG_amount_CTE on Count_orders_and_common_sum_CTE.create_date = AVG_amount_CTE.create_date;