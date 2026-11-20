#salues value by order status
with status_sales as (
    select
        o.status,
        sum(oi.sale_price) as sales_value,
        count(distinct o.order_id) as order_count,
        count(*) as positions_count
    from `bigquery-public-data.thelook_ecommerce.orders` o
    join `bigquery-public-data.thelook_ecommerce.order_items` oi
        on o.order_id = oi.order_id
    where o.created_at >= timestamp('2019-02-01')
        and o.created_at < timestamp('2026-11-01')
    group by o.status
)

select
    status,
    round(sales_value, 2) as sales_value,
    order_count,
    positions_count,
    round(
        (sales_value / sum(sales_value) over ()) * 100,
        2
    ) as sales_value_percentage
from status_sales
order by sales_value desc;


#sales value and aov by order month
select
    date_trunc(date(o.created_at), month) as order_month,
    sum(oi.sale_price) as sales_value,
	count(distinct o.order_id) as order_count,
	round(sum(oi.sale_price) / count(distinct o.order_id),2) as average_order_value
from `bigquery-public-data.thelook_ecommerce.orders` o
join `bigquery-public-data.thelook_ecommerce.order_items` oi
    on o.order_id = oi.order_id
where o.created_at >= timestamp('2019-02-01')
    and o.created_at < timestamp('2026-11-01')
group by order_month
order by order_month;

#sales value by product category
select
    p.category,
    round(sum(oi.sale_price),2) as sales_value,
	count(*) as sold_positions,
	round(avg(oi.sale_price),2) as avg_item_price
from `bigquery-public-data.thelook_ecommerce.products` p
join `bigquery-public-data.thelook_ecommerce.order_items` oi
    on p.id = oi.product_id
join `bigquery-public-data.thelook_ecommerce.orders` o
    on oi.order_id = o.order_id
where o.created_at >= timestamp('2019-02-01')
    and o.created_at < timestamp('2026-11-01')
group by p.category
order by sales_value desc;

#top 10 products by sales value
select
    p.id as product_id,
    p.name as product_name,
    p.category,
    round(sum(oi.sale_price),2) as sales_value,
    count(*) as sold_positions
from `bigquery-public-data.thelook_ecommerce.products` p
join `bigquery-public-data.thelook_ecommerce.order_items` oi
    on p.id = oi.product_id
join `bigquery-public-data.thelook_ecommerce.orders` o
    on oi.order_id = o.order_id
where o.created_at >= timestamp('2019-02-01')
    and o.created_at < timestamp('2026-11-01')
group by p.id, p.name, p.category
order by sales_value desc, sold_positions desc
limit 10;

#top 10 products by number of items sold
select
    p.id as product_id,
    p.name as product_name,
    p.category,
    round(sum(oi.sale_price),2) as sales_value,
    count(*) as sold_positions
from `bigquery-public-data.thelook_ecommerce.products` p
join `bigquery-public-data.thelook_ecommerce.order_items` oi
    on p.id = oi.product_id
join `bigquery-public-data.thelook_ecommerce.orders` o
    on oi.order_id = o.order_id
where o.created_at >= timestamp('2019-02-01')
    and o.created_at < timestamp('2026-11-01')
group by p.id, p.name, p.category
order by sold_positions desc, sales_value desc
limit 10;

#top 10 prodocuts by estimated gross profit
select
    p.id as product_id,
    p.name as product_name,
    p.category,
    round(sum(oi.sale_price),2) as sales_value,
    round(sum(p.cost),2) as total_cost,
    round(sum(oi.sale_price - p.cost),2) as gross_profit,
    round(safe_divide(
        sum(oi.sale_price - p.cost),
        sum(oi.sale_price)
    ) * 100,2) as gross_margin_pct,
    count(*) as sold_positions
from `bigquery-public-data.thelook_ecommerce.products` p
join `bigquery-public-data.thelook_ecommerce.order_items` oi
    on p.id = oi.product_id
join `bigquery-public-data.thelook_ecommerce.orders` o
    on oi.order_id = o.order_id
where o.created_at >= timestamp('2019-02-01')
    and o.created_at < timestamp('2026-11-01')
    and o.status = 'Complete'
group by p.id, p.name, p.category
order by gross_profit desc
limit 10;

#top 10 products by estimated gross margin
select
    p.id as product_id,
    p.name as product_name,
    p.category,
    round(sum(oi.sale_price),2) as sales_value,
    round(sum(p.cost),2) as total_cost,
    round(sum(oi.sale_price - p.cost),2) as gross_profit,
    round(safe_divide(
        sum(oi.sale_price - p.cost),
        sum(oi.sale_price)
    ) * 100,2) as gross_margin_pct,
    count(*) as sold_positions
from `bigquery-public-data.thelook_ecommerce.products` p
join `bigquery-public-data.thelook_ecommerce.order_items` oi
    on p.id = oi.product_id
join `bigquery-public-data.thelook_ecommerce.orders` o
    on oi.order_id = o.order_id
where o.created_at >= timestamp('2019-02-01')
    and o.created_at < timestamp('2026-11-01')
    and o.status = 'Complete'
group by p.id, p.name, p.category
order by gross_margin_pct desc
limit 10;

#gross profit and gross margin by product category
select
    p.category,
    round(sum(oi.sale_price),2) as sales_value,
    round(sum(p.cost),2) as total_cost,
    round(sum(oi.sale_price - p.cost),2) as gross_profit,
    round(
        safe_divide(
            sum(oi.sale_price - p.cost),
            sum(oi.sale_price)
        ) * 100,
        2
    ) as gross_margin_pct,
    count(*) as sold_positions
from `bigquery-public-data.thelook_ecommerce.products` p
join `bigquery-public-data.thelook_ecommerce.order_items` oi
    on p.id = oi.product_id
join `bigquery-public-data.thelook_ecommerce.orders` o
    on oi.order_id = o.order_id
where o.created_at >= timestamp('2019-02-01')
    and o.created_at < timestamp('2026-11-01')
    and o.status = 'Complete'
group by p.category
order by gross_profit desc;