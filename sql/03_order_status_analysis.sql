#order status distribution
select
    status,
    count(*) as total_orders,
    round(
        count(*) * 100.0 / sum(count(*)) over (),
        2
    ) as percentage
from `bigquery-public-data.thelook_ecommerce.orders`
where created_at >= timestamp('2019-02-01')
    and created_at < timestamp('2026-11-01')
group by status
order by total_orders desc;

#order items status distribution
select
    oi.status,
    count(*) as total_order_items,
    round(
        count(*) * 100.0 / sum(count(*)) over (),
        2
    ) as percentage
from `bigquery-public-data.thelook_ecommerce.orders` o
join `bigquery-public-data.thelook_ecommerce.order_items` oi
    on o.order_id = oi.order_id
where o.created_at >= timestamp('2019-02-01')
    and o.created_at < timestamp('2026-11-01')
group by oi.status
order by total_order_items desc;

#order and item status consistency
select
    o.status as order_status,
    oi.status as item_status,
    count(*) as total_items
from `bigquery-public-data.thelook_ecommerce.orders` o
join `bigquery-public-data.thelook_ecommerce.order_items` oi
    on o.order_id = oi.order_id
where o.created_at >= timestamp('2019-02-01')
    and o.created_at < timestamp('2026-11-01')
group by
    o.status,
    oi.status
order by
    o.status,
    total_items desc;

  #sales value by order status
  with status_sales as (
    select
        o.status,
        count(distinct o.order_id) as total_orders,
        count(oi.id) as total_order_items,
        sum(oi.sale_price) as sales_value
    from `bigquery-public-data.thelook_ecommerce.orders` o
    join `bigquery-public-data.thelook_ecommerce.order_items` oi
        on o.order_id = oi.order_id
where o.created_at >= timestamp('2019-02-01')
    and o.created_at < timestamp('2026-11-01')
    group by o.status
)

select
    status,
    total_orders,
    total_order_items,
    round(sales_value, 2) as sales_value,
    round(
        sales_value * 100 / sum(sales_value) over (),
        2
    ) as sales_value_percentage
from status_sales
order by sales_value desc;