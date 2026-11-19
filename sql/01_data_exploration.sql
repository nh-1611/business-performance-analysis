#row count by table
select
    'products' as table_name,
    count(*) as row_count
from `bigquery-public-data.thelook_ecommerce.products`

union all

select
    'orders' as table_name,
    count(*) as row_count
from `bigquery-public-data.thelook_ecommerce.orders`

union all

select
    'order_items' as table_name,
    count(*) as row_count
from `bigquery-public-data.thelook_ecommerce.order_items`

union all

select
    'inventory_items' as table_name,
    count(*) as row_count
from `bigquery-public-data.thelook_ecommerce.inventory_items`;

#table schema overview
select
    table_name,
    column_name,
    data_type,
    is_nullable
from `bigquery-public-data.thelook_ecommerce.INFORMATION_SCHEMA.COLUMNS`
where table_name in (
    'products',
    'orders',
    'order_items',
    'inventory_items'
)
order by
    table_name,
    ordinal_position;

#monthly order volumne
select
    extract(year from created_at) as order_year,
    extract(month from created_at) as order_month,
    count(*) as total_orders,
    count(distinct user_id) as unique_customers
from `bigquery-public-data.thelook_ecommerce.orders`
group by
    order_year,
    order_month
order by
    order_year,
    order_month;

#dataset date coverage
select
    min(created_at) as first_order_date,
    max(created_at) as last_order_date,
    count(distinct date_trunc(date(created_at), month)) as number_of_months,
    count(*) as total_orders
from `bigquery-public-data.thelook_ecommerce.orders`;