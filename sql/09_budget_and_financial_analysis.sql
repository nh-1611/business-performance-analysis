#table structure overview
select
    table_name,
    column_name,
    data_type
from
    `brilliant-will-515216-p2.portfolio_procurement.INFORMATION_SCHEMA.COLUMNS`
where
    table_name in (
        'budgets',
        'supplier_invoices',
        'supplier_invoice_lines',
        'purchase_order_items'
    )
order by
    table_name,
    ordinal_position;

#monthly budget overview
select
    month_start,
    sum(budget_amount) as total_monthly_budget,
    count(distinct category) as categories_covered,
    round(avg(budget_amount), 2) as avg_category_budget,
    min(budget_amount) as min_category_budget,
    max(budget_amount) as max_category_budget
from
    `brilliant-will-515216-p2.portfolio_procurement.budgets`
where month_start < date '2026-11-01'
group by month_start
order by month_start;

#actual procurement spending by month and category
select
    date_trunc(si.invoice_date, month) as month_start,
    poi.category,
    count(distinct si.invoice_id) as invoice_count,
    sum(sil.invoiced_quantity) as total_invoiced_quantity,
    round(sum(sil.line_amount), 2) as actual_spending
from
    `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
join
    `brilliant-will-515216-p2.portfolio_procurement.supplier_invoice_lines` sil
    on si.invoice_id = sil.invoice_id
join
    `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    on sil.po_item_id = poi.po_item_id
where
    si.invoice_date >= date '2025-01-01'
    and si.invoice_date < date '2026-11-01'
group by
    month_start,
    poi.category
order by
    month_start,
    actual_spending desc;

#budget vs actual procurement spending
with actual_spending as (
    select
        date_trunc(si.invoice_date, month) as month_start,
        poi.category,
        sum(sil.line_amount) as actual_spending
    from
        `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    join
        `brilliant-will-515216-p2.portfolio_procurement.supplier_invoice_lines` sil
        on si.invoice_id = sil.invoice_id
    join
        `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
        on sil.po_item_id = poi.po_item_id
    where
        si.invoice_date >= date '2025-01-01'
        and si.invoice_date < date '2026-11-01'
    group by
        month_start,
        poi.category
)

select
    b.month_start,
    b.category,
    b.budget_amount,
    round(coalesce(a.actual_spending, 0), 2) as actual_spending,
    round(
        b.budget_amount - coalesce(a.actual_spending, 0),
        2
    ) as remaining_budget,
    round(
        safe_divide(
            coalesce(a.actual_spending, 0),
            b.budget_amount
        ) * 100,
        2
    ) as budget_utilization_pct
from
    `brilliant-will-515216-p2.portfolio_procurement.budgets` b
left join
    actual_spending a
    on b.month_start = a.month_start
    and b.category = a.category
where
    b.month_start < date '2026-11-01'
order by
    b.month_start,
    budget_utilization_pct desc;

#budget utilization by category
with actual_spending as (
    select
        poi.category,
        sum(sil.line_amount) as total_actual_spending
    from
        `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    join
        `brilliant-will-515216-p2.portfolio_procurement.supplier_invoice_lines` sil
        on si.invoice_id = sil.invoice_id
    join
        `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
        on sil.po_item_id = poi.po_item_id
    where
        si.invoice_date >= date '2025-01-01'
        and si.invoice_date < date '2026-11-01'
    group by
        poi.category
),

budget_summary as (
    select
        category,
        sum(budget_amount) as total_budget
    from
        `brilliant-will-515216-p2.portfolio_procurement.budgets`
    where
        month_start < date '2026-11-01'
    group by
        category
)

select
    b.category,
    b.total_budget,
    round(coalesce(a.total_actual_spending, 0), 2) as total_actual_spending,
    round(
        b.total_budget - coalesce(a.total_actual_spending, 0),
        2
    ) as remaining_budget,
    round(
        safe_divide(
            coalesce(a.total_actual_spending, 0),
            b.total_budget
        ) * 100,
        2
    ) as budget_utilization_pct
from
    budget_summary b
left join
    actual_spending a
    on b.category = a.category
order by
    budget_utilization_pct desc;

#monthly budget utilization
with actual_spending as (
    select
        date_trunc(si.invoice_date, month) as month_start,
        sum(sil.line_amount) as total_actual_spending
    from
        `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    join
        `brilliant-will-515216-p2.portfolio_procurement.supplier_invoice_lines` sil
        on si.invoice_id = sil.invoice_id
    where
        si.invoice_date >= date '2025-01-01'
        and si.invoice_date < date '2026-11-01'
    group by
        month_start
),

monthly_budget as (
    select
        month_start,
        sum(budget_amount) as total_budget
    from
        `brilliant-will-515216-p2.portfolio_procurement.budgets`
    where
        month_start < date '2026-11-01'
    group by
        month_start
)

select
    b.month_start,
    b.total_budget,
    round(coalesce(a.total_actual_spending, 0), 2) as actual_spending,
    round(
        b.total_budget - coalesce(a.total_actual_spending, 0),
        2
    ) as remaining_budget,
    round(
        safe_divide(
            coalesce(a.total_actual_spending, 0),
            b.total_budget
        ) * 100,
        2
    ) as budget_utilization_pct
from
    monthly_budget b
left join
    actual_spending a
    on b.month_start = a.month_start
order by
    b.month_start;

#budget monitoring and variance analysis
with actual_spending as (
    select
        date_trunc(si.invoice_date, month) as month_start,
        poi.category,
        sum(sil.line_amount) as actual_spending
    from
        `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    join
        `brilliant-will-515216-p2.portfolio_procurement.supplier_invoice_lines` sil
        on si.invoice_id = sil.invoice_id
    join
        `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
        on sil.po_item_id = poi.po_item_id
    where
        si.invoice_date >= date '2025-01-01'
        and si.invoice_date < date '2026-11-01'
    group by
        month_start,
        poi.category
),

budget_monitoring as (
    select
        b.month_start,
        b.category,
        b.budget_amount,
        coalesce(a.actual_spending, 0) as actual_spending,
        safe_divide(
            coalesce(a.actual_spending, 0),
            b.budget_amount
        ) * 100 as utilization_pct
    from
        `brilliant-will-515216-p2.portfolio_procurement.budgets` b
    left join
        actual_spending a
        on b.month_start = a.month_start
        and b.category = a.category
    where
        b.month_start < date '2026-11-01'
)

select
    case
        when utilization_pct > 100 then 'over budget'
        when utilization_pct >= 80 then 'high utilization'
        when utilization_pct >= 50 then 'moderate utilization'
        else 'low utilization'
    end as budget_status,
    count(*) as category_month_count,
    round(sum(budget_amount), 2) as total_budget,
    round(sum(actual_spending), 2) as actual_spending,
    round(sum(budget_amount - actual_spending), 2) as remaining_budget,
    round(avg(utilization_pct), 2) as avg_utilization_pct
from
    budget_monitoring
group by
    budget_status
order by
    avg_utilization_pct desc;