#purchase order value by supplier
select
    s.supplier_id,
    s.supplier_name,
    count(distinct po.po_id) as total_orders,
    count(poi.po_item_id) as total_order_lines,
    sum(poi.ordered_quantity) as total_ordered_quantity,
    round(sum(poi.line_total), 2) as total_order_value,
    round(avg(poi.line_total), 2) as avg_order_line_value
from `brilliant-will-515216-p2.portfolio_procurement.suppliers` s
join `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
    on s.supplier_id = po.supplier_id
join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    on po.po_id = poi.po_id
where po.po_status != 'cancelled'
group by
    s.supplier_id,
    s.supplier_name
order by total_order_value desc;

#purchase order status analysis
select
    po_status,
    count(*) as total_orders,
    round(
        count(*) * 100.0 / sum(count(*)) over (),
        2
    ) as percentage
from `brilliant-will-515216-p2.portfolio_procurement.purchase_orders`
group by po_status
order by total_orders desc;

#ordered vs received quantity by supplier
select
    s.supplier_id,
    s.supplier_name,
    sum(poi.ordered_quantity) as total_ordered_quantity,
    sum(coalesce(gr.received_quantity, 0)) as total_received_quantity,
    sum(
        poi.ordered_quantity - coalesce(gr.received_quantity, 0)
    ) as outstanding_quantity,
    round(
        safe_divide(
            sum(coalesce(gr.received_quantity, 0)),
            sum(poi.ordered_quantity)
        ) * 100,
        2
    ) as fulfillment_rate
from `brilliant-will-515216-p2.portfolio_procurement.suppliers` s
join `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
    on s.supplier_id = po.supplier_id
join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    on po.po_id = poi.po_id
left join `brilliant-will-515216-p2.portfolio_procurement.goods_receipts` gr
    on poi.po_item_id = gr.po_item_id
where po.po_status != 'cancelled'
group by
    s.supplier_id,
    s.supplier_name
order by fulfillment_rate asc;

#outstanding purchase order value by supplier
select
    s.supplier_id,
    s.supplier_name,
    round(
        sum(
            (poi.ordered_quantity - coalesce(gr.received_quantity, 0))
            * poi.unit_cost
        ),
        2
    ) as outstanding_order_value,
    sum(
        poi.ordered_quantity - coalesce(gr.received_quantity, 0)
    ) as outstanding_quantity
from `brilliant-will-515216-p2.portfolio_procurement.suppliers` s
join `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
    on s.supplier_id = po.supplier_id
join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    on po.po_id = poi.po_id
left join `brilliant-will-515216-p2.portfolio_procurement.goods_receipts` gr
    on poi.po_item_id = gr.po_item_id
where po.po_status != 'cancelled'
group by
    s.supplier_id,
    s.supplier_name
having outstanding_quantity > 0
order by outstanding_order_value desc;

#purchase order delivery performance
select
    s.supplier_id,
    s.supplier_name,
    count(poi.po_item_id) as total_order_lines,
    countif(gr.received_quantity > 0) as received_order_lines,
    countif(
        gr.received_quantity > 0
        and date(gr.received_date) <= date(po.expected_delivery_date)
    ) as on_time_order_lines,
    countif(
        gr.received_quantity > 0
        and date(gr.received_date) > date(po.expected_delivery_date)
    ) as late_order_lines,
    round(
        safe_divide(
            countif(
                gr.received_quantity > 0
                and date(gr.received_date) <= date(po.expected_delivery_date)
            ),
            countif(gr.received_quantity > 0)
        ) * 100,
        2
    ) as on_time_delivery_rate
from `brilliant-will-515216-p2.portfolio_procurement.suppliers` s
join `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
    on s.supplier_id = po.supplier_id
join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    on po.po_id = poi.po_id
left join `brilliant-will-515216-p2.portfolio_procurement.goods_receipts` gr
    on poi.po_item_id = gr.po_item_id
where po.po_status != 'cancelled'
group by
    s.supplier_id,
    s.supplier_name
order by on_time_delivery_rate asc;

#procurement value by product category
select
    poi.category,
    count(distinct po.po_id) as total_orders,
    sum(poi.ordered_quantity) as total_ordered_quantity,
    round(sum(poi.line_total), 2) as total_purchase_value,
    round(avg(poi.unit_cost), 2) as avg_unit_cost,
    round(
        safe_divide(
            sum(poi.line_total),
            sum(sum(poi.line_total)) over ()
        ) * 100,
        2
    ) as percentage_of_total_value
from `brilliant-will-515216-p2.portfolio_procurement.purchase_orders` po
join `brilliant-will-515216-p2.portfolio_procurement.purchase_order_items` poi
    on po.po_id = poi.po_id
where po.po_status != 'cancelled'
group by poi.category
order by total_purchase_value desc;