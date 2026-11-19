#primary keys validation
select
    'products' as table_name,
    count(*) as total_rows,
    count(id) as non_null_ids,
    count(distinct id) as unique_ids,
    count(*) - count(id) as null_ids,
    count(id) - count(distinct id) as duplicate_ids
from `bigquery-public-data.thelook_ecommerce.products`

union all

select
    'orders',
    count(*),
    count(order_id),
    count(distinct order_id),
    count(*) - count(order_id),
    count(order_id) - count(distinct order_id)
from `bigquery-public-data.thelook_ecommerce.orders`

union all

select
    'order_items',
    count(*),
    count(id),
    count(distinct id),
    count(*) - count(id),
    count(id) - count(distinct id)
from `bigquery-public-data.thelook_ecommerce.order_items`

union all

select
    'inventory_items',
    count(*),
    count(id),
    count(distinct id),
    count(*) - count(id),
    count(id) - count(distinct id)
from `bigquery-public-data.thelook_ecommerce.inventory_items`;

#foreign keys validation
select
    'order_items -> products' as relationship,
    count(*) as total_rows,
    countif(p.id is null) as unmatched_rows
from `bigquery-public-data.thelook_ecommerce.order_items` oi
left join `bigquery-public-data.thelook_ecommerce.products` p
    on oi.product_id = p.id

union all

select
    'order_items -> orders',
    count(*),
    countif(o.order_id is null)
from `bigquery-public-data.thelook_ecommerce.order_items` oi
left join `bigquery-public-data.thelook_ecommerce.orders` o
    on oi.order_id = o.order_id

union all

select
    'order_items -> inventory_items',
    count(*),
    countif(i.id is null)
from `bigquery-public-data.thelook_ecommerce.order_items` oi
left join `bigquery-public-data.thelook_ecommerce.inventory_items` i
    on oi.inventory_item_id = i.id;

#foreign keys consistency
select
    'user_id consistency' as check_name,
    count(*) as total_rows,
    countif(o.user_id != oi.user_id) as inconsistent_rows
from `bigquery-public-data.thelook_ecommerce.order_items` oi
join `bigquery-public-data.thelook_ecommerce.orders` o
    on oi.order_id = o.order_id

union all

select
    'product_id consistency',
    count(*),
    countif(oi.product_id != i.product_id)
from `bigquery-public-data.thelook_ecommerce.order_items` oi
join `bigquery-public-data.thelook_ecommerce.inventory_items` i
    on oi.inventory_item_id = i.id;

#inventory item uniqueness in orders
select
    count(*) as total_order_items,
    count(distinct inventory_item_id) as unique_inventory_items,
    count(*) - count(distinct inventory_item_id) as repeated_inventory_items
from `bigquery-public-data.thelook_ecommerce.order_items`;

#null inventory items ids
select
    count(*) as total_rows,
    countif(inventory_item_id is null) as null_inventory_item_ids
from `bigquery-public-data.thelook_ecommerce.order_items`;

#distribution centers relationship validation
select
    count(*) as total_products,
    countif(p.distribution_center_id is null) as null_distribution_center_ids,
    countif(dc.id is null) as unmatched_distribution_centers
from `bigquery-public-data.thelook_ecommerce.products` p
left join `bigquery-public-data.thelook_ecommerce.distribution_centers` dc
    on p.distribution_center_id = dc.id;

#products numeric validation
select
    count(*) as total_products,
    countif(cost is null) as null_cost,
    countif(cost < 0) as negative_cost,
    countif(cost = 0) as zero_cost,
    countif(retail_price is null) as null_retail_price,
    countif(retail_price < 0) as negative_retail_price,
    countif(retail_price = 0) as zero_retail_price
from `bigquery-public-data.thelook_ecommerce.products`;

#order items validation
select
    count(*) as total_order_items,
    countif(sale_price is null) as null_sale_price,
    countif(sale_price < 0) as negative_sale_price,
    countif(sale_price = 0) as zero_sale_price,
    countif(order_id is null) as null_order_id,
    countif(product_id is null) as null_product_id,
    countif(inventory_item_id is null) as null_inventory_item_id,
    countif(created_at is null) as null_created_at
from `bigquery-public-data.thelook_ecommerce.order_items`;

#orders validation
select
    count(*) as total_orders,
    countif(user_id is null) as null_user_id,
    countif(status is null) as null_status,
    countif(created_at is null) as null_created_at,
    countif(num_of_item is null) as null_num_of_item,
    countif(num_of_item <= 0) as non_positive_num_of_item,
    countif(shipped_at < created_at) as shipped_before_created,
    countif(delivered_at < shipped_at) as delivered_before_shipped,
    countif(returned_at < created_at) as returned_before_created
from `bigquery-public-data.thelook_ecommerce.orders`;

#inventory items validation
select
    count(*) as total_inventory_items,
    countif(product_id is null) as null_product_id,
    countif(cost is null) as null_cost,
    countif(cost < 0) as negative_cost,
    countif(cost = 0) as zero_cost,
    countif(product_retail_price is null) as null_retail_price,
    countif(product_retail_price < 0) as negative_retail_price,
    countif(product_retail_price = 0) as zero_retail_price,
    countif(created_at is null) as null_created_at,
    countif(sold_at < created_at) as sold_before_created
from `bigquery-public-data.thelook_ecommerce.inventory_items`;

#distribution centers validation
select
    count(*) as total_distribution_centers,
    countif(name is null) as null_name,
    countif(latitude is null) as null_latitude,
    countif(longitude is null) as null_longitude,
    countif(latitude < -90 or latitude > 90) as invalid_latitude,
    countif(longitude < -180 or longitude > 180) as invalid_longitude,
    countif(distribution_center_geom is null) as null_geometry
from `bigquery-public-data.thelook_ecommerce.distribution_centers`;

#order items count consistency
with order_item_counts as (
    select
        order_id,
        count(*) as actual_num_of_items
    from `bigquery-public-data.thelook_ecommerce.order_items`
    group by order_id
)

select
    count(*) as total_orders,
    countif(o.num_of_item != coalesce(oi.actual_num_of_items, 0)) as inconsistent_orders,
    countif(oi.actual_num_of_items is null) as orders_without_items
from `bigquery-public-data.thelook_ecommerce.orders` o
left join order_item_counts oi
    on o.order_id = oi.order_id;

#sale price consistency
select
    count(*) as total_order_items,
    countif(oi.sale_price = p.retail_price) as matching_prices,
    countif(oi.sale_price != p.retail_price) as different_prices,
    round(avg(oi.sale_price - p.retail_price), 2) as avg_price_difference,
    round(min(oi.sale_price - p.retail_price), 2) as min_price_difference,
    round(max(oi.sale_price - p.retail_price), 2) as max_price_difference
from `bigquery-public-data.thelook_ecommerce.order_items` oi
join `bigquery-public-data.thelook_ecommerce.products` p
    on oi.product_id = p.id;