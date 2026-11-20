#inventory overview
select
    count(*) as total_inventory_items,
    countif(sold_at is not null) as sold_items,
    countif(sold_at is null) as unsold_items,
    round(
        safe_divide(countif(sold_at is not null), count(*)) * 100,
        2
    ) as sold_items_percentage,
    round(
        safe_divide(countif(sold_at is null), count(*)) * 100,
        2
    ) as unsold_items_percentage
from `bigquery-public-data.thelook_ecommerce.inventory_items`;

#inventory by product category
select
    p.category,
    count(*) as total_inventory_items,
    countif(ii.sold_at is not null) as sold_items,
    countif(ii.sold_at is null) as unsold_items,
    round(
        safe_divide(countif(ii.sold_at is not null), count(*)) * 100,
        2
    ) as sold_items_percentage,
    round(
        safe_divide(countif(ii.sold_at is null), count(*)) * 100,
        2
    ) as unsold_items_percentage
from `bigquery-public-data.thelook_ecommerce.inventory_items` ii
join `bigquery-public-data.thelook_ecommerce.products` p
    on ii.product_id = p.id
group by p.category
order by total_inventory_items desc;

#inventory by product
select
    p.id as product_id,
    p.name as product_name,
    p.category,
    count(*) as total_inventory_items,
    countif(ii.sold_at is not null) as sold_items,
    countif(ii.sold_at is null) as unsold_items,
    round(
        safe_divide(countif(ii.sold_at is null), count(*)) * 100,
        2
    ) as unsold_items_percentage
from `bigquery-public-data.thelook_ecommerce.inventory_items` ii
join `bigquery-public-data.thelook_ecommerce.products` p
    on ii.product_id = p.id
group by p.id, p.name, p.category
order by unsold_items desc
limit 10;

#inventory aging analysis
with inventory_aging as (
    select
        id,
        product_id,
        sold_at,
        date_diff(
            coalesce(date(sold_at), date('2026-11-19')),
            date(created_at),
            day
        ) as days_in_inventory
    from `bigquery-public-data.thelook_ecommerce.inventory_items`
)

select
    case
        when days_in_inventory <= 30 then '0-30 days'
        when days_in_inventory <= 60 then '31-60 days'
        when days_in_inventory <= 90 then '61-90 days'
        when days_in_inventory <= 180 then '91-180 days'
        else 'Over 180 days'
    end as inventory_age_group,
    count(*) as total_items,
    countif(sold_at is not null) as sold_items,
    countif(sold_at is null) as unsold_items
from inventory_aging
group by inventory_age_group
order by
    case inventory_age_group
        when '0-30 days' then 1
        when '31-60 days' then 2
        when '61-90 days' then 3
        when '91-180 days' then 4
        else 5
    end;

#inventory value
select
    round(sum(p.cost), 2) as total_inventory_value,
    round(sum(case
        when ii.sold_at is not null then p.cost
        else 0
    end), 2) as sold_inventory_value,
    round(sum(case
        when ii.sold_at is null then p.cost
        else 0
    end), 2) as unsold_inventory_value,
    round(
        safe_divide(
            sum(case when ii.sold_at is null then p.cost else 0 end),
            sum(p.cost)
        ) * 100,
        2
    ) as unsold_inventory_value_percentage
from `bigquery-public-data.thelook_ecommerce.inventory_items` ii
join `bigquery-public-data.thelook_ecommerce.products` p
    on ii.product_id = p.id;