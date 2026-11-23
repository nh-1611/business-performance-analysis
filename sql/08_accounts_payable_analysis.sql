#invoice overview by supplier
select
    s.supplier_id,
    s.supplier_name,
    count(si.invoice_id) as total_invoices,
    round(sum(si.invoice_amount), 2) as total_invoice_value,
    round(avg(si.invoice_amount), 2) as avg_invoice_value,
    min(si.invoice_date) as first_invoice_date,
    max(si.invoice_date) as last_invoice_date
from `brilliant-will-515216-p2.portfolio_procurement.suppliers` s
join `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    on s.supplier_id = si.supplier_id
where si.invoice_date < date '2026-11-01'
group by
    s.supplier_id,
    s.supplier_name
order by total_invoice_value desc;

#invoice payment status
with payment_summary as (
    select
        invoice_id,
        sum(payment_amount) as total_paid
    from `brilliant-will-515216-p2.portfolio_procurement.supplier_payments`
    where payment_date < date '2026-11-01'
    group by invoice_id
),

invoice_balances as (
    select
        si.invoice_id,
        si.invoice_number,
        si.invoice_amount,
        coalesce(ps.total_paid, 0) as total_paid,
        si.invoice_amount - coalesce(ps.total_paid, 0) as outstanding_amount,
        case
            when coalesce(ps.total_paid, 0) = 0 then 'unpaid'
            when coalesce(ps.total_paid, 0) < si.invoice_amount then 'partially_paid'
            else 'paid'
        end as payment_status
    from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    left join payment_summary ps
        on si.invoice_id = ps.invoice_id
    where si.invoice_date < date '2026-11-01'
)

select
    payment_status,
    count(*) as total_invoices,
    round(sum(invoice_amount), 2) as total_invoice_value,
    round(sum(total_paid), 2) as total_paid,
    round(sum(outstanding_amount), 2) as outstanding_amount
from invoice_balances
group by payment_status
order by total_invoices desc;

#outstanding invoice balance by supplier
with payment_summary as (
    select
        invoice_id,
        sum(payment_amount) as total_paid
    from `brilliant-will-515216-p2.portfolio_procurement.supplier_payments`
    where payment_date < date '2026-11-01'
    group by invoice_id
)

select
    s.supplier_id,
    s.supplier_name,
    countif(
        coalesce(ps.total_paid, 0) < si.invoice_amount
    ) as outstanding_invoices,
    round(
        sum(
            greatest(
                si.invoice_amount - coalesce(ps.total_paid, 0),
                0
            )
        ),
        2
    ) as total_outstanding_amount,
    round(
        avg(
            case
                when coalesce(ps.total_paid, 0) < si.invoice_amount
                then si.invoice_amount - coalesce(ps.total_paid, 0)
            end
        ),
        2
    ) as avg_outstanding_invoice
from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
join `brilliant-will-515216-p2.portfolio_procurement.suppliers` s
    on si.supplier_id = s.supplier_id
left join payment_summary ps
    on si.invoice_id = ps.invoice_id
where si.invoice_date < date '2026-11-01'
group by
    s.supplier_id,
    s.supplier_name
having total_outstanding_amount > 0
order by total_outstanding_amount desc;

#invoice aging analysis
with payment_summary as (
    select
        invoice_id,
        sum(payment_amount) as total_paid
    from `brilliant-will-515216-p2.portfolio_procurement.supplier_payments`
    where payment_date < date '2026-11-01'
    group by invoice_id
),

invoice_balances as (
    select
        si.invoice_id,
        si.invoice_number,
        si.due_date,
        si.invoice_amount,
        greatest(
            si.invoice_amount - coalesce(ps.total_paid, 0),
            0
        ) as outstanding_amount,
        date_diff(
            date '2026-11-19',
            si.due_date,
            day
        ) as days_overdue
    from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    left join payment_summary ps
        on si.invoice_id = ps.invoice_id
    where si.invoice_date < date '2026-11-01'
    and si.invoice_amount > coalesce(ps.total_paid, 0)
)

select
    case
        when days_overdue <= 0 then 'not yet due'
        when days_overdue between 1 and 30 then '1-30 days overdue'
        when days_overdue between 31 and 60 then '31-60 days overdue'
        else 'over 60 days overdue'
    end as aging_bucket,
    count(*) as total_invoices,
    round(sum(outstanding_amount), 2) as outstanding_amount,
    round(avg(outstanding_amount), 2) as avg_outstanding_amount
from invoice_balances
group by aging_bucket
order by
    case aging_bucket
        when 'not yet due' then 1
        when '1-30 days overdue' then 2
        when '31-60 days overdue' then 3
        else 4
    end;

#payment performance by supplier
with payment_summary as (
    select
        invoice_id,
        sum(payment_amount) as total_paid,
        max(payment_date) as final_payment_date
    from `brilliant-will-515216-p2.portfolio_procurement.supplier_payments`
    where payment_date < date '2026-11-01'
    group by invoice_id
),

invoice_payment_status as (
    select
        s.supplier_id,
        s.supplier_name,
        si.invoice_id,
        si.invoice_date,
        si.due_date,
        si.invoice_amount,
        ps.total_paid,
        ps.final_payment_date,
        date_diff(
            ps.final_payment_date,
            si.due_date,
            day
        ) as days_from_due_date,
        date_diff(
            ps.final_payment_date,
            si.invoice_date,
            day
        ) as days_to_payment
    from `brilliant-will-515216-p2.portfolio_procurement.supplier_invoices` si
    join `brilliant-will-515216-p2.portfolio_procurement.suppliers` s
        on si.supplier_id = s.supplier_id
    join payment_summary ps
        on si.invoice_id = ps.invoice_id
    where si.invoice_date < date '2026-11-01'
    and ps.total_paid >= si.invoice_amount
)

select
    supplier_id,
    supplier_name,
    count(*) as paid_invoices,
    countif(days_from_due_date <= 0) as on_time_payments,
    countif(days_from_due_date > 0) as late_payments,
    round(
        safe_divide(
            countif(days_from_due_date <= 0),
            count(*)
        ) * 100,
        2
    ) as on_time_payment_rate,
    round(avg(days_to_payment), 2) as avg_days_to_payment,
    round(avg(days_from_due_date), 2) as avg_days_from_due_date
from invoice_payment_status
group by
    supplier_id,
    supplier_name
order by on_time_payment_rate desc;

#monthly payment activity
select
    date_trunc(payment_date, month) as payment_month,
    count(*) as total_payments,
    count(distinct invoice_id) as invoices_paid,
    round(sum(payment_amount), 2) as total_payment_value,
    round(avg(payment_amount), 2) as avg_payment_value
from `brilliant-will-515216-p2.portfolio_procurement.supplier_payments`
where payment_date < date '2026-11-01'
group by payment_month
order by payment_month;