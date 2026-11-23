#product sample for procurement dataset

with ranked_products as (
    select
        id as product_id,
        name as product_name,
        category,
        cost,
        row_number() over (
            partition by category
            order by id
        ) as product_rank
    from `bigquery-public-data.thelook_ecommerce.products`
    where cost is not null
        and cost > 0
)

select
    product_id,
    product_name,
    category,
    cost
from ranked_products
where product_rank <= 3
order by category, product_id;

#schema
create schema if not exists `brilliant-will-515216-p2.portfolio_procurement`
options(location = 'US');

#suppliers
create or replace table `brilliant-will-515216-p2.portfolio_procurement.suppliers` as

select *
from unnest([
    struct(1 as supplier_id, 'Northstar Apparel Ltd.' as supplier_name, 'United States' as country, 30 as payment_terms_days),
    struct(2, 'Urban Textile Group', 'United States', 14),
    struct(3, 'Pacific Fashion Supply', 'China', 60),
    struct(4, 'EuroStyle Manufacturing', 'Germany', 30),
    struct(5, 'Classic Wear Industries', 'Italy', 30),
    struct(6, 'Global Garment Partners', 'Bangladesh', 60),
    struct(7, 'BluePeak Clothing Co.', 'Vietnam', 45),
    struct(8, 'Summit Outdoor Goods', 'United States', 30),
    struct(9, 'Evergreen Accessories', 'China', 14),
    struct(10, 'Prime Denim Suppliers', 'Turkey', 30),
    struct(11, 'Luxe Fashion Wholesale', 'France', 60),
    struct(12, 'Metro Basics Trading', 'India', 30),
    struct(13, 'Silverline Sportswear', 'Portugal', 45),
    struct(14, 'Heritage Apparel Co.', 'United Kingdom', 30),
    struct(15, 'Vertex Retail Supply', 'Poland', 14)
]);

#suppliers data check

select
    count(*) as total_suppliers,
    count(distinct supplier_id) as unique_supplier_ids,
    count(distinct supplier_name) as unique_supplier_names,
    min(payment_terms_days) as min_payment_terms,
    max(payment_terms_days) as max_payment_terms
from portfolio_procurement.suppliers;

#purchase orders table
create or replace table `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` as

select
    po_id,
    format('PO-%04d', po_id) as po_number,
    mod(po_id - 1, 15) + 1 as supplier_id,
    date_add(date '2025-01-01', interval mod(po_id * 37, 669) day) as order_date,
    date_add(
        date_add(date '2025-01-01', interval mod(po_id * 37, 669) day),
        interval 7 + mod(po_id * 13, 24) day
    ) as expected_delivery_date,
    case
        when mod(po_id, 20) = 0 then 'cancelled'
        when mod(po_id, 10) = 0 then 'open'
        when mod(po_id, 7) = 0 then 'partially_received'
        else 'received'
    end as po_status
from unnest(generate_array(1, 180)) as po_id;

#purchase orders quality check
select
    count(*) as total_purchase_orders,
    count(distinct po_id) as unique_po_ids,
    count(distinct po_number) as unique_po_numbers,
    countif(supplier_id not in (
        select supplier_id
        from `brilliant-will-515216-p2.portfolio_procurement.suppliers`
    )) as unmatched_supplier_ids,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    min(expected_delivery_date) as earliest_expected_delivery,
    max(expected_delivery_date) as latest_expected_delivery
from `brilliant-will-515216-p2.portfolio_procurement.purchase_orders`;

#purchase orders status distribution
select
    po_status,
    count(*) as total_orders,
    round(count(*) * 100.0 / sum(count(*)) over (), 2) as percentage
from `brilliant-will-515216-p2.portfolio_procurement.purchase_orders`
group by po_status
order by total_orders desc;

#purchase order items table
create or replace table `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` as

with product_sample as (
    select
        id as product_id,
        category,
        cost
    from `bigquery-public-data.thelook_ecommerce.products`
    where cost is not null
        and cost > 0
    qualify row_number() over (
        partition by category
        order by id
    ) <= 3
),

order_lines as (
    select
        po.po_id,
        line_number,
        mod(po.po_id * 7 + line_number * 13, 20) + 1 as ordered_quantity,
        p.product_id,
        p.category,
        p.cost
    from `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
    cross join unnest(generate_array(1, 2 + mod(po.po_id, 4))) as line_number
    cross join product_sample p
    qualify row_number() over (
        partition by po.po_id, line_number
        order by farm_fingerprint(cast(concat(cast(po.po_id as string), '-', cast(line_number as string), '-', cast(p.product_id as string)) as string))
    ) = 1
)

select
    row_number() over (order by po_id, line_number) as po_item_id,
    po_id,
    product_id,
    category,
    ordered_quantity,
    cost as unit_cost,
    round(ordered_quantity * cost, 2) as line_total
from order_lines;

#purchase order items quality check
select
    count(*) as total_po_items,
    count(distinct po_item_id) as unique_po_item_ids,
    countif(po.po_id is null) as unmatched_po_ids,
    countif(p.id is null) as unmatched_product_ids,
    countif(ordered_quantity <= 0) as invalid_quantities,
    countif(unit_cost <= 0) as invalid_unit_costs,
    countif(abs(line_total - ordered_quantity * unit_cost) > 0.01) as incorrect_line_totals
from `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
left join `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
    on poi.po_id = po.po_id
left join `bigquery-public-data.thelook_ecommerce.products` p
    on poi.product_id = p.id;

#purchase order value
select
    po.po_id,
    po.po_number,
    po.po_status,
    count(poi.po_item_id) as total_items,
    sum(poi.ordered_quantity) as total_ordered_quantity,
    round(sum(poi.line_total), 2) as purchase_order_value
from `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    on po.po_id = poi.po_id
group by
    po.po_id,
    po.po_number,
    po.po_status
order by purchase_order_value desc;

#goods receipts table
create or replace table `brilliant-will-515216-p2.portfolio_procurement.goods_receipts` as

with receipt_data as (
    select
        poi.po_item_id,
        poi.po_id,
        poi.ordered_quantity,
        po.order_date,
        po.expected_delivery_date,
        po.po_status,
        mod(poi.po_item_id * 7, 10) as receipt_pattern
    from `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    join `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
        on poi.po_id = po.po_id
    where po.po_status != 'cancelled'
),

calculated_receipts as (
    select
        *,
        case
            when po_status = 'received' then
                case
                    when receipt_pattern = 0 then ordered_quantity - 1
                    else ordered_quantity
                end
            when po_status = 'partially_received' then
                greatest(1, cast(ordered_quantity * 0.6 as int64))
            when po_status = 'open' and receipt_pattern < 3 then
                greatest(1, cast(ordered_quantity * 0.4 as int64))
            else 0
        end as received_quantity
    from receipt_data
)

select
    row_number() over (order by po_item_id) as receipt_id,
    po_item_id,
    po_id,
    received_quantity,
    date_add(
        expected_delivery_date,
        interval mod(po_item_id * 3, 15) day
    ) as received_date
from calculated_receipts
where received_quantity > 0;

#goods receipts quality check
select
    count(*) as total_receipt_records,
    count(distinct receipt_id) as unique_receipt_ids,
    countif(poi.po_item_id is null) as unmatched_po_item_ids,
    countif(po.po_id is null) as unmatched_po_ids,
    countif(received_quantity <= 0) as invalid_received_quantities,
    countif(received_date is null) as missing_received_dates,
    countif(received_date < po.order_date) as receipts_before_order
from `brilliant-will-515216-p2.portfolio_procurement.goods_receipts` gr
left join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    on gr.po_item_id = poi.po_item_id
left join `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
    on gr.po_id = po.po_id;

#ordered vs received quantity
select
    po.po_id,
    po.po_number,
    po.po_status,
    sum(poi.ordered_quantity) as ordered_quantity,
    coalesce(sum(gr.received_quantity), 0) as received_quantity,
    sum(poi.ordered_quantity) - coalesce(sum(gr.received_quantity), 0) as outstanding_quantity
from `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    on po.po_id = poi.po_id
left join `brilliant-will-515216-p2.portfolio_procurement.goods_receipts` gr
    on poi.po_item_id = gr.po_item_id
group by
    po.po_id,
    po.po_number,
    po.po_status
order by outstanding_quantity desc;

#supplier invoices table
create or replace table `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` as

with po_values as (
    select
        po.po_id,
        po.supplier_id,
        po.order_date,
        po.expected_delivery_date,
        po.po_status,
        sum(poi.line_total) as po_value
    from `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
    join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
        on po.po_id = poi.po_id
    group by
        po.po_id,
        po.supplier_id,
        po.order_date,
        po.expected_delivery_date,
        po.po_status
),

invoice_data as (
    select
        pv.*,
        s.payment_terms_days,
        mod(pv.po_id, 10) as invoice_pattern
    from po_values pv
    join `brilliant-will-515216-p2.portfolio_procurement.suppliers` s
        on pv.supplier_id = s.supplier_id
    where pv.po_status != 'cancelled'
)

select
    row_number() over (order by po_id) as invoice_id,
    format('INV-%04d', po_id) as invoice_number,
    po_id,
    supplier_id,
    date_add(order_date, interval 3 + mod(po_id * 5, 20) day) as invoice_date,
    date_add(
        date_add(order_date, interval 3 + mod(po_id * 5, 20) day),
        interval payment_terms_days day
    ) as due_date,
    round(
        po_value *
        case
            when invoice_pattern in (0, 1) then 0.6
            when invoice_pattern = 2 then 0.8
            else 1.0
        end,
        2
    ) as invoice_amount
from invoice_data;

#supplier invoices quality check
select
    count(*) as total_invoices,
    count(distinct invoice_id) as unique_invoice_ids,
    count(distinct invoice_number) as unique_invoice_numbers,
    countif(po.po_id is null) as unmatched_po_ids,
    countif(s.supplier_id is null) as unmatched_supplier_ids,
    countif(invoice_amount <= 0) as invalid_invoice_amounts,
    countif(due_date < invoice_date) as invalid_due_dates,
    countif(invoice_date < po.order_date) as invoices_before_order
from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
left join `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
    on si.po_id = po.po_id
left join `brilliant-will-515216-p2.portfolio_procurement.suppliers` s
    on si.supplier_id = s.supplier_id;

#invoice overview
select
    count(*) as total_invoices,
    round(sum(invoice_amount), 2) as total_invoice_amount,
    round(avg(invoice_amount), 2) as average_invoice_amount,
    min(invoice_date) as first_invoice_date,
    max(invoice_date) as last_invoice_date
from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices`;

#supplier invoice lines table
create or replace table `brilliant-will-515216-p2.portfolio_procurement.supplier_invoice_lines` as

with invoice_items as (
    select
        si.invoice_id,
        si.po_id,
        poi.po_item_id,
        poi.product_id,
        poi.ordered_quantity,
        poi.unit_cost,
        row_number() over (
            partition by si.invoice_id
            order by poi.po_item_id
        ) as item_number
    from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
        on si.po_id = poi.po_id
)

select
    row_number() over (order by invoice_id, po_item_id) as invoice_line_id,
    invoice_id,
    po_item_id,
    product_id,
    case
        when mod(po_item_id, 10) = 0 then greatest(1, cast(ordered_quantity * 0.8 as int64))
        else ordered_quantity
    end as invoiced_quantity,
    unit_cost,
    round(
        case
            when mod(po_item_id, 10) = 0 then greatest(1, cast(ordered_quantity * 0.8 as int64))
            else ordered_quantity
        end * unit_cost,
        2
    ) as line_amount
from invoice_items;

#supplier invoice lines quality check
select
    count(*) as total_invoice_lines,
    count(distinct sil.invoice_line_id) as unique_invoice_line_ids,
    countif(si.invoice_id is null) as unmatched_invoice_ids,
    countif(poi.po_item_id is null) as unmatched_po_item_ids,
    countif(p.id is null) as unmatched_product_ids,
    countif(sil.invoiced_quantity <= 0) as invalid_invoiced_quantities,
    countif(sil.line_amount <= 0) as invalid_line_amounts,
    countif(abs(sil.line_amount - sil.invoiced_quantity * sil.unit_cost) > 0.01) as incorrect_line_amounts
from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoice_lines` sil
left join `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    on sil.invoice_id = si.invoice_id
left join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    on sil.po_item_id = poi.po_item_id
left join `bigquery-public-data.thelook_ecommerce.products` p
    on sil.product_id = p.id;

#invoice amount reconciliation
select
    si.invoice_number,
    round(si.invoice_amount, 2) as invoice_header_amount,
    round(sum(sil.line_amount), 2) as invoice_lines_amount,
    round(si.invoice_amount - sum(sil.line_amount), 2) as amount_difference
from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
join `brilliant-will-515216-p2.portfolio_procurement.supplier_invoice_lines` sil
    on si.invoice_id = sil.invoice_id
group by
    si.invoice_id,
    si.invoice_number,
    si.invoice_amount
order by abs(amount_difference) desc;

#update supplier invoice amounts
create or replace table `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` as

select
    si.invoice_id,
    si.invoice_number,
    si.po_id,
    si.supplier_id,
    si.invoice_date,
    si.due_date,
    round(sum(sil.line_amount), 2) as invoice_amount
from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
join `brilliant-will-515216-p2.portfolio_procurement.supplier_invoice_lines` sil
    on si.invoice_id = sil.invoice_id
group by
    si.invoice_id,
    si.invoice_number,
    si.po_id,
    si.supplier_id,
    si.invoice_date,
    si.due_date;

#supplier payments table
create or replace table `brilliant-will-515216-p2.portfolio_procurement.supplier_payments` as

with payment_patterns as (
    select
        si.invoice_id,
        si.invoice_number,
        si.invoice_date,
        si.due_date,
        si.invoice_amount,
        mod(si.invoice_id, 10) as payment_pattern
    from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
),

payment_data as (
    select
        *,
        case
            when payment_pattern between 0 and 4 then 1
            when payment_pattern between 5 and 6 then 2
            else 0
        end as payment_count
    from payment_patterns
),

generated_payments as (
    select
        pd.*,
        payment_number,
        case
            when payment_count = 1 then invoice_amount
            when payment_count = 2 and payment_number = 1 then round(invoice_amount * 0.6, 2)
            when payment_count = 2 then round(invoice_amount - round(invoice_amount * 0.6, 2), 2)
        end as payment_amount
    from payment_data pd
    cross join unnest(generate_array(1, greatest(payment_count, 1))) as payment_number
    where payment_count > 0
)

select
    row_number() over (order by invoice_id, payment_number) as payment_id,
    invoice_id,
    format('PAY-%05d', row_number() over (order by invoice_id, payment_number)) as payment_reference,
    payment_amount,
    date_add(
        due_date,
        interval case
            when payment_pattern in (0, 1) then 5 + mod(invoice_id, 12)
            when payment_pattern in (2, 3) then -5
            else mod(invoice_id, 8)
        end day
    ) as payment_date
from generated_payments;

#supplier payments quality check
select
    count(*) as total_payments,
    count(distinct payment_id) as unique_payment_ids,
    count(distinct payment_reference) as unique_payment_references,
    countif(si.invoice_id is null) as unmatched_invoice_ids,
    countif(payment_amount <= 0) as invalid_payment_amounts,
    countif(payment_date is null) as missing_payment_dates
from `brilliant-will-515216-p2.portfolio_procurement.supplier_payments` sp
left join `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    on sp.invoice_id = si.invoice_id;

#invoice payment status
select
    si.invoice_number,
    si.invoice_amount,
    coalesce(sum(sp.payment_amount), 0) as paid_amount,
    round(si.invoice_amount - coalesce(sum(sp.payment_amount), 0), 2) as outstanding_amount,
    case
        when coalesce(sum(sp.payment_amount), 0) = 0 then 'unpaid'
        when coalesce(sum(sp.payment_amount), 0) < si.invoice_amount then 'partially_paid'
        when coalesce(sum(sp.payment_amount), 0) = si.invoice_amount then 'paid'
        else 'overpaid'
    end as payment_status
from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
left join `brilliant-will-515216-p2.portfolio_procurement.supplier_payments` sp
    on si.invoice_id = sp.invoice_id
group by
    si.invoice_id,
    si.invoice_number,
    si.invoice_amount
order by outstanding_amount desc;

#budgets table
create or replace table `brilliant-will-515216-p2.portfolio_procurement.budgets` as

with categories as (
    select distinct
        category
    from `bigquery-public-data.thelook_ecommerce.products`
    where category is not null
),

months as (
    select
        month_start
    from unnest(
        generate_date_array(
            date '2025-01-01',
            date '2026-10-01',
            interval 1 month
        )
    ) as month_start
)

select
    row_number() over (order by m.month_start, c.category) as budget_id,
    m.month_start,
    c.category,
    cast(
        15000 + mod(
            farm_fingerprint(concat(c.category, cast(m.month_start as string))),
            10000
        ) as numeric
    ) as budget_amount
from months m
cross join categories c;

#budgets quality check
select
    count(*) as total_budget_records,
    count(distinct budget_id) as unique_budget_ids,
    count(distinct concat(cast(month_start as string), '-', category)) as unique_month_category_pairs,
    countif(budget_amount <= 0) as invalid_budget_amounts,
    min(month_start) as first_budget_month,
    max(month_start) as last_budget_month,
    count(distinct category) as total_categories
from `brilliant-will-515216-p2.portfolio_procurement.budgets`;

#monthly budget overview
select
    month_start,
    round(sum(budget_amount), 2) as total_monthly_budget,
    count(distinct category) as categories_covered
from `brilliant-will-515216-p2.portfolio_procurement.budgets`
group by month_start
order by month_start;