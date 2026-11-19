# Initial Order Analysis

## 1. Objective

The purpose of the initial order analysis was to understand the distribution of order statuses, compare order-level and item-level classifications, and prepare the dataset for subsequent sales and financial analysis.

## 2. Reporting period

The analysis uses orders created after 31 January 2019 and before 1 November 2026.

## 3. Order status distribution

The order-level status analysis identified the following categories:

| Status | Orders | Share |
|---|---:|---:|
| Shipped | 35,765 | 30.37% |
| Complete | 29,050 | 24.66% |
| Processing | 23,630 | 20.06% |
| Cancelled | 17,677 | 15.01% |
| Returned | 11,660 | 9.90% |

The distribution provides an overview of the order lifecycle and the relative size of each status category.

## 4. Order-level vs item-level status

The status distribution was also examined at the individual order item level.

A cross-table consistency check compared `orders.status` with `order_items.status`.

**Result:** Every checked order item had the same status as its parent order.

This indicates that, in the selected dataset, order status can be used to classify individual order items.

## 5. Analytical considerations

- Order counts and order item counts have different denominators; their percentage distributions should not be compared as if they represented the same population.
- Status-based sales values require careful interpretation.
- Cancelled and returned orders should be examined separately before defining the final sales and revenue metrics.
- The analysis uses the order creation date as the reporting-period filter to maintain a consistent order cohort.
