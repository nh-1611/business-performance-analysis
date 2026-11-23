# 06. Procurement & Accounts Payable Dataset

## 1. Overview

This phase introduces a synthetic Procurement and Accounts Payable (AP) dataset designed to extend the original TheLook e-commerce analysis.

The original dataset provides information about products, orders, sales, and inventory, but does not contain procurement transactions, supplier invoices, or payment records. To enable further analysis of purchasing activities and financial obligations, eight additional tables were created in BigQuery.

The synthetic dataset allows the project to demonstrate procurement analysis, supplier performance monitoring, invoice reconciliation, payment tracking, and budget analysis.

## 2. Dataset Structure

The dataset consists of eight interconnected tables.

| Table | Description | Grain |
|---|---|---|
| `suppliers` | Supplier master data, including payment terms | One row per supplier |
| `purchase_orders` | Purchase order headers and their statuses | One row per purchase order |
| `purchase_order_items` | Products and quantities included in purchase orders | One row per purchase order line |
| `goods_receipts` | Records of goods received against purchase order lines | One row per purchase order line |
| `supplier_invoices` | Supplier invoice headers and invoice amounts | One row per invoice |
| `supplier_invoice_lines` | Individual invoice lines linked to purchase order items | One row per invoice line |
| `supplier_payments` | Payments made against supplier invoices | One row per payment |
| `budgets` | Monthly budgets assigned to product categories | One row per category and month |

## 3. Table Construction

### 3.1 Suppliers

The `suppliers` table contains 15 synthetic suppliers.

Each supplier has a unique identifier and name, together with payment terms ranging from 14 to 60 days.

The table serves as the supplier reference table for purchase orders and supports supplier-level analysis.

### 3.2 Purchase Orders

The `purchase_orders` table contains 180 synthetic purchase orders.

Each record includes:
- Purchase order ID and number
- Supplier ID
- Order date
- Expected delivery date
- Purchase order status

Four purchase order statuses were introduced:

- `received`
- `partially_received`
- `open`
- `cancelled`

Cancelled purchase orders are excluded from most purchasing value analyses because they do not represent active purchasing commitments.

### 3.3 Purchase Order Items

The `purchase_order_items` table contains the individual product lines associated with purchase orders.

Each purchase order contains between two and five lines.

The table includes:
- Purchase order item ID
- Purchase order ID
- Product ID
- Product category
- Ordered quantity
- Unit cost
- Line total

Line totals are calculated as:

`ordered_quantity × unit_cost`

Products and their costs are sourced from the original TheLook dataset. This creates a connection between the synthetic procurement data and the original product catalogue.

### 3.4 Goods Receipts

The `goods_receipts` table records quantities received against purchase order items.

The generated receipt quantities depend on the purchase order status:
- Received orders generally have their full quantities received, with some minor shortfalls.
- Partially received orders have approximately 60% of their ordered quantities received.
- Selected open orders have approximately 40% of their quantities received.

Receipt dates are generated in relation to expected delivery dates.

The table makes it possible to compare ordered and received quantities and identify outstanding quantities.

**Important limitation:** Each purchase order item has one receipt record. The dataset therefore does not represent multiple separate delivery events for the same order line.

### 3.5 Supplier Invoices

The `supplier_invoices` table contains 171 synthetic supplier invoices.

Each invoice is associated with a purchase order and includes:
- Invoice ID and number
- Supplier and purchase order references
- Invoice date
- Due date
- Invoice amount

Payment due dates are based on supplier payment terms.

Invoice amounts were initially generated as a percentage of purchase order values. They were subsequently recalculated using the corresponding invoice lines to ensure consistency between invoice headers and line-level amounts.

### 3.6 Supplier Invoice Lines

The `supplier_invoice_lines` table contains individual items included in supplier invoices.

Each invoice line is linked to a purchase order item and contains:
- Invoice line ID
- Invoice ID
- Purchase order item ID
- Invoiced quantity
- Unit cost
- Line amount

Most invoiced quantities correspond to the ordered quantities, while selected lines contain a lower invoiced quantity.

Line amounts are calculated as:

`invoiced_quantity × unit_cost`

Invoice header amounts are reconciled against the sum of their invoice line amounts.

### 3.7 Supplier Payments

The `supplier_payments` table contains synthetic payment transactions.

Three payment scenarios were introduced:
- Fully paid invoices with one payment.
- Partially paid invoices with two payments, representing 60% and 40% of the invoice amount.
- Unpaid invoices without payment records.

Payment dates are generated in relation to invoice due dates, allowing subsequent analysis of payment status and payment timeliness.

### 3.8 Budgets

The `budgets` table contains monthly budgets for 26 product categories.

The data covers the period from January 2025 to October 2026, resulting in 572 records.

Each record contains:
- Budget month
- Product category
- Budget amount

Budget values are synthetically generated using deterministic logic.

The table supports monthly and category-level budget analysis, as well as comparisons between budgets and purchasing activity.

## 4. Data Quality and Validation

Several validation queries were executed to verify the structure and consistency of the generated dataset.

The checks covered the following areas:

| Validation Area | Purpose |
|---|---|
| Row counts | Verify the number of records generated in each table |
| Unique identifiers | Check whether primary identifiers are unique |
| Supplier references | Verify that purchase orders reference existing suppliers |
| Purchase order references | Verify relationships between purchase orders and their line items |
| Product references | Confirm that purchase order items reference existing products |
| Receipt reconciliation | Compare ordered and received quantities |
| Invoice reconciliation | Compare invoice header amounts with invoice line totals |
| Payment validation | Check payment records and invoice payment statuses |
| Budget completeness | Verify category coverage and monthly records |

### Key Validation Results

- 15 unique suppliers were created.
- Supplier identifiers and supplier names were unique.
- Supplier payment terms ranged from 14 to 60 days.
- Purchase order item records were successfully linked to purchase orders and products.
- Goods receipt records were successfully generated.
- Invoice header amounts were reconciled with invoice line totals.
- Payment records were generated according to the defined payment scenarios.
- The budget table contains 26 categories for each of the 22 months.
- The monthly budget overview confirmed that all 26 categories were represented in every month.

## 5. Data Relationships

The tables are connected through the following key relationships:

- `suppliers.supplier_id` → `purchase_orders.supplier_id`
- `purchase_orders.po_id` → `purchase_order_items.po_id`
- `purchase_order_items.po_item_id` → `goods_receipts.po_item_id`
- `purchase_orders.po_id` → `supplier_invoices.po_id`
- `supplier_invoices.invoice_id` → `supplier_invoice_lines.invoice_id`
- `purchase_order_items.po_item_id` → `supplier_invoice_lines.po_item_id`
- `supplier_invoices.invoice_id` → `supplier_payments.invoice_id`
- `purchase_order_items.product_id` → `products.id`

These relationships connect supplier information, purchasing activity, goods receipts, invoices, and payments.

The `budgets` table is connected to the product catalogue through product categories when performing category-level analysis.

## 6. Dataset Limitations and Assumptions

The procurement and accounts payable data is synthetic and should not be interpreted as actual business transaction data.

The following limitations should be considered during analysis:

1. **Synthetic transactions:** Purchase orders, invoices, receipts, payments, and budgets were generated for portfolio purposes.
2. **Simplified goods receipt process:** Each purchase order item has one receipt record rather than multiple delivery events.
3. **Simplified invoice process:** Invoice lines are linked directly to purchase order items. The dataset does not model every possible real-world invoice discrepancy or adjustment.
4. **Simplified payment scenarios:** Payment patterns are generated using predefined rules rather than actual supplier payment behaviour.
5. **Budget assumptions:** Monthly budgets are generated values and do not represent approved business budgets.
6. **Limited accounting information:** The dataset does not contain a complete general ledger, tax records, credit notes, or verified cash flow information.

Consequently, the results of subsequent analyses should be presented as analytical findings based on a simulated business environment rather than as evidence of actual company performance.

## 7. Purpose of the Dataset

The additional dataset extends the original e-commerce analysis beyond sales and inventory.

It enables the project to explore several business and financial questions:

- Which suppliers account for the highest purchasing value?
- How much has been ordered compared with how much has been received?
- Which purchase orders have outstanding quantities?
- How much do suppliers invoice the business?
- What is the outstanding accounts payable balance?
- Are supplier invoices paid on time?
- How does purchasing activity compare with available budgets?
- Which product categories have the highest budget allocation?

## 8. Conclusion

The synthetic procurement dataset provides the additional transactional structure required to analyse purchasing and accounts payable processes alongside the original TheLook e-commerce data.

The eight tables were created and validated in BigQuery, with checks covering identifiers, table relationships, receipt quantities, invoice reconciliation, payment records, and budget completeness.

This dataset establishes the foundation for the next phase: **Procurement Analysis**, focusing on supplier purchasing activity, purchase order values, and goods receipt performance.
