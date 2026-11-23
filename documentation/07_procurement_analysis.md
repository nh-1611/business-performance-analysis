# 07. Procurement Analysis

## 1. Overview

This phase focuses on analysing procurement activities using the synthetic Procurement and Accounts Payable dataset created before.

The analysis examines purchasing activity across suppliers and product categories, purchase order statuses, goods receipt performance, outstanding quantities, and delivery timeliness.

The main objective is to understand how purchasing activity is distributed, identify suppliers with the highest outstanding order values, and evaluate the fulfilment of purchase orders.

## 2. Purchase Order Value by Supplier

### Objective

The first analysis evaluates purchasing activity across suppliers by comparing the total value and volume of their purchase orders.

Cancelled purchase orders are excluded because they do not represent active purchasing activity.

### Metrics

- `total_orders` – number of non-cancelled purchase orders.
- `total_order_lines` – number of purchase order line items.
- `total_ordered_quantity` – total quantity of products ordered.
- `total_order_value` – total value of purchase order lines.
- `avg_order_line_value` – average value of an individual purchase order line.

### Key Findings

- **Summit Outdoor Goods** recorded the highest purchase order value at **$24,124.26**.
- **EuroStyle Manufacturing** ranked second with $22,659.53.
- **Metro Basics Trading** ranked third with $20,415.53.
- **Global Garment Partners** recorded the lowest purchase order value at $11,549.96.
- Most suppliers had 12 purchase orders and 42 order lines. Three suppliers had 9 purchase orders and 36 order lines.

### Business Interpretation

The results indicate that purchasing value is not determined solely by the number of purchase orders.

For example, Summit Outdoor Goods and Global Garment Partners both had 12 purchase orders, but Summit recorded more than twice the purchasing value.

This suggests that differences in ordered quantities, product costs, and product mix contribute to variations in purchasing value.

## 3. Purchase Order Status Analysis

### Objective

This analysis examines the distribution of purchase order statuses to assess the overall progress of procurement activities.

All 180 purchase orders are included.

### Key Findings

| Purchase Order Status | Total Orders | Percentage |
|---|---:|---:|
| Received | 139 | 77.22% |
| Partially Received | 23 | 12.78% |
| Cancelled | 9 | 5.00% |
| Open | 9 | 5.00% |
| **Total** | **180** | **100.00%** |

### Business Interpretation

- 77.22% of purchase orders were marked as received.
- 12.78% were partially received, indicating that some ordered quantities remained outstanding.
- 5% remained open and required further monitoring.
- 5% were cancelled and were excluded from subsequent purchasing and receipt performance calculations.

The results indicate that most purchase orders reached the received status.

However, purchase order status alone does not confirm that all ordered quantities were received. Therefore, a separate quantity-level analysis was performed.

## 4. Ordered vs Received Quantity by Supplier

### Objective

This analysis compares ordered quantities with received quantities for each supplier.

It provides a more detailed assessment of purchase order fulfilment than the status analysis.

Cancelled purchase orders are excluded.

### Metrics

- `total_ordered_quantity` – total quantity ordered.
- `total_received_quantity` – total quantity recorded as received.
- `outstanding_quantity` – quantity ordered but not yet received.
- `fulfillment_rate` – percentage of ordered quantities received.

The fulfilment rate is calculated as:

`received quantity / ordered quantity × 100`

### Key Findings

| Supplier | Ordered Quantity | Received Quantity | Outstanding Quantity | Fulfillment Rate |
|---|---:|---:|---:|---:|
| Classic Wear Industries | 375 | 266 | 109 | 70.93% |
| Prime Denim Suppliers | 375 | 266 | 109 | 70.93% |
| Vertex Retail Supply | 375 | 280 | 95 | 74.67% |
| Heritage Apparel Co. | 474 | 427 | 47 | 90.08% |
| Global Garment Partners | 402 | 371 | 31 | 92.29% |
| Metro Basics Trading | 426 | 396 | 30 | 92.96% |
| BluePeak Clothing Co. | 426 | 397 | 29 | 93.19% |
| EuroStyle Manufacturing | 474 | 442 | 32 | 93.25% |
| Pacific Fashion Supply | 450 | 422 | 28 | 93.78% |
| Luxe Fashion Wholesale | 402 | 377 | 25 | 93.78% |
| Summit Outdoor Goods | 450 | 422 | 28 | 93.78% |
| Northstar Apparel Ltd. | 402 | 379 | 23 | 94.28% |
| Silverline Sportswear | 450 | 426 | 24 | 94.67% |
| Urban Textile Group | 426 | 411 | 15 | 96.48% |
| Evergreen Accessories | 474 | 464 | 10 | 97.89% |

### Overall Results

| Metric | Value |
|---|---:|
| Total Ordered Quantity | 6,351 |
| Total Received Quantity | 5,746 |
| Outstanding Quantity | 605 |
| Overall Fulfillment Rate | 90.47% |

### Business Interpretation

The overall fulfilment rate was 90.47%, meaning that 9.53% of ordered quantities remained outstanding.

Three suppliers recorded notably lower fulfilment rates:

- Classic Wear Industries – 70.93%.
- Prime Denim Suppliers – 70.93%.
- Vertex Retail Supply – 74.67%.

Together, these suppliers accounted for 313 outstanding units.

In contrast, Evergreen Accessories achieved the highest fulfilment rate of 97.89%, with only 10 outstanding units.

The results suggest that outstanding quantities are concentrated among a small group of suppliers. These suppliers could be prioritised for further investigation.

## 5. Outstanding Purchase Order Value by Supplier

### Objective

The previous analysis identified outstanding quantities. This analysis converts those quantities into monetary values using the unit costs recorded in purchase order items.

It helps identify suppliers responsible for the largest estimated value of undelivered products.

### Calculation

`outstanding quantity × unit cost`

Cancelled purchase orders are excluded.

### Key Findings

| Supplier | Outstanding Order Value | Outstanding Quantity |
|---|---:|---:|
| Classic Wear Industries | $4,417.87 | 109 |
| Prime Denim Suppliers | $4,333.17 | 109 |
| Vertex Retail Supply | $2,734.74 | 95 |
| EuroStyle Manufacturing | $1,881.88 | 32 |
| Heritage Apparel Co. | $1,605.15 | 47 |
| Metro Basics Trading | $1,465.93 | 30 |
| Summit Outdoor Goods | $1,346.15 | 28 |
| Urban Textile Group | $1,238.50 | 15 |
| BluePeak Clothing Co. | $1,112.73 | 29 |
| Silverline Sportswear | $948.55 | 24 |
| Northstar Apparel Ltd. | $900.39 | 23 |
| Pacific Fashion Supply | $804.88 | 28 |
| Global Garment Partners | $791.39 | 31 |
| Luxe Fashion Wholesale | $684.04 | 25 |
| Evergreen Accessories | $235.11 | 10 |

### Overall Results

The total estimated outstanding purchase order value was **$21,501.34**, corresponding to 605 outstanding units.

The three suppliers with the highest outstanding values were:

- Classic Wear Industries – $4,417.87.
- Prime Denim Suppliers – $4,333.17.
- Vertex Retail Supply – $2,734.74.

Together, they accounted for approximately **53.4%** of the total outstanding order value.

### Business Interpretation

The results confirm that suppliers with the lowest fulfilment rates also account for the highest outstanding purchase order values.

This concentration suggests that procurement monitoring should prioritise Classic Wear Industries, Prime Denim Suppliers, and Vertex Retail Supply.

The outstanding order value represents the estimated cost value of products not yet received. It should not be interpreted as an accounts payable balance or an amount owed to suppliers.

## 6. Purchase Order Delivery Performance

### Objective

This analysis evaluates whether received purchase order lines were delivered on or before their expected delivery dates.

The analysis compares the recorded goods receipt date with the expected delivery date specified in the purchase order.

Cancelled purchase orders are excluded.

### Metrics

- `total_order_lines` – total purchase order lines.
- `received_order_lines` – lines with a positive received quantity.
- `on_time_order_lines` – received lines recorded on or before the expected delivery date.
- `late_order_lines` – received lines recorded after the expected delivery date.
- `on_time_delivery_rate` – percentage of received lines delivered on time.

The on-time delivery rate is calculated as:

`on-time received lines / received order lines × 100`

### Key Findings

| Supplier | Received Lines | On-Time Lines | Late Lines | On-Time Delivery Rate |
|---|---:|---:|---:|---:|
| Evergreen Accessories | 42 | 6 | 36 | 14.29% |
| BluePeak Clothing Co. | 42 | 6 | 36 | 14.29% |
| Heritage Apparel Co. | 42 | 6 | 36 | 14.29% |
| Urban Textile Group | 42 | 6 | 36 | 14.29% |
| Metro Basics Trading | 42 | 6 | 36 | 14.29% |
| EuroStyle Manufacturing | 42 | 6 | 36 | 14.29% |
| Silverline Sportswear | 39 | 6 | 33 | 15.38% |
| Summit Outdoor Goods | 39 | 6 | 33 | 15.38% |
| Pacific Fashion Supply | 40 | 7 | 33 | 17.50% |
| Luxe Fashion Wholesale | 42 | 9 | 33 | 21.43% |
| Northstar Apparel Ltd. | 42 | 9 | 33 | 21.43% |
| Global Garment Partners | 42 | 9 | 33 | 21.43% |
| Classic Wear Industries | 27 | 6 | 21 | 22.22% |
| Vertex Retail Supply | 27 | 6 | 21 | 22.22% |
| Prime Denim Suppliers | 27 | 6 | 21 | 22.22% |

### Overall Results

| Metric | Value |
|---|---:|
| Received Order Lines | 577 |
| On-Time Order Lines | 100 |
| Late Order Lines | 477 |
| Overall On-Time Delivery Rate | 17.33% |

### Business Interpretation

Only 17.33% of received purchase order lines were recorded as delivered on time.

The highest on-time delivery rate was 22.22%, achieved by Classic Wear Industries, Vertex Retail Supply, and Prime Denim Suppliers.

The lowest rate was 14.29%, shared by six suppliers.

However, the differences between suppliers are relatively small.

**Data limitation:** The synthetic dataset uses predefined logic to generate goods receipt dates. Consequently, the delivery performance results may reflect the data generation rules rather than realistic supplier delivery behaviour.

Furthermore, each purchase order item has one receipt record. The analysis measures the recorded receipt date at the order-line level and does not model multiple delivery events or the full timeline of partial deliveries.

The results should therefore be treated as a demonstration of delivery performance analysis rather than a reliable assessment of actual supplier performance.

## 7. Procurement Value by Product Category

### Objective

The final analysis examines purchasing activity across product categories.

It identifies which categories account for the largest share of total purchase order value and compares purchasing value with ordered quantities and average unit costs.

Cancelled purchase orders are excluded.

### Metrics

- `total_orders` – number of distinct purchase orders containing products from a category.
- `total_ordered_quantity` – total number of units ordered.
- `total_purchase_value` – total purchase order value.
- `avg_unit_cost` – average unit cost of products in the category.
- `percentage_of_total_value` – category share of total purchasing value.

### Key Findings

| Category | Purchase Value | Share of Total Value |
|---|---:|---:|
| Suits & Sport Coats | $26,100.05 | 10.84% |
| Sweaters | $23,066.80 | 9.58% |
| Suits | $21,175.15 | 8.80% |
| Jumpsuits & Rompers | $20,188.58 | 8.39% |
| Outerwear & Coats | $18,824.64 | 7.82% |
| Jeans | $17,788.45 | 7.39% |
| Pants & Capris | $13,700.15 | 5.69% |
| Tops & Tees | $9,706.48 | 4.03% |
| Dresses | $9,385.46 | 3.90% |
| Blazers & Jackets | $7,990.43 | 3.32% |

The remaining categories each accounted for less than 3.2% of total purchasing value.

### Key Observations

- Suits & Sport Coats recorded the highest purchasing value at $26,100.05, representing 10.84% of total value.
- Sweaters ranked second, accounting for 9.58%.
- The five highest-value categories represented approximately 45.43% of total purchasing value.
- Shorts recorded the lowest purchasing value at $1,783.10, representing 0.74%.
- Socks and Socks & Hosiery also accounted for relatively small shares of total purchasing value.

### Business Interpretation

The results demonstrate that purchasing value is influenced by both ordered quantities and unit costs.

For example:

- Suits & Sport Coats: 237 units ordered, with an average unit cost of $110.23.
- Socks & Hosiery: 263 units ordered, with an average unit cost of $7.83.

Although more units were ordered in Socks & Hosiery, the purchasing value of Suits & Sport Coats was substantially higher.

This demonstrates why purchasing activity should be evaluated using both volume-based and value-based metrics.

**Additional note:** The number of purchase orders across categories should not be summed to calculate the total number of purchase orders. A single purchase order can contain products from multiple categories and therefore appear in more than one category.

## 8. Overall Business Findings

The procurement analysis produced several important findings:

1. **Purchasing concentration:** Summit Outdoor Goods recorded the highest purchase order value at $24,124.26.
2. **Purchase order completion:** 77.22% of purchase orders were marked as received.
3. **Quantity fulfilment:** The overall fulfilment rate was 90.47%, with 605 outstanding units.
4. **Supplier performance:** Classic Wear Industries, Prime Denim Suppliers, and Vertex Retail Supply recorded the lowest fulfilment rates.
5. **Outstanding purchasing value:** The total estimated value of outstanding purchase order quantities was $21,501.34.
6. **Outstanding value concentration:** The three suppliers with the highest outstanding values accounted for approximately 53.4% of the total.
7. **Delivery timeliness:** The overall on-time delivery rate was 17.33%, although the synthetic date generation limits the reliability of supplier comparisons.
8. **Category spending:** Suits & Sport Coats accounted for the largest share of purchasing value at 10.84%.

## 9. Limitations

Several limitations should be considered when interpreting the results:

- Procurement transactions are synthetic and do not represent actual business activity.
- Purchase order values are based on generated quantities and product costs sourced from TheLook.
- Outstanding purchase order value represents estimated undelivered product costs, not accounts payable.
- A purchase order marked as received does not necessarily mean that every ordered unit was received.
- Goods receipt data contains one record per purchase order item rather than multiple delivery events.
- Delivery dates are generated using predefined rules, limiting the reliability of on-time delivery comparisons.
- Supplier performance indicators should be interpreted as results within the simulated dataset.
- Category-level purchase order counts are not additive because individual orders may contain multiple categories.

## 10. Conclusion

The Procurement Analysis phase provides an overview of purchasing activity, supplier fulfilment, outstanding order quantities, delivery timeliness, and purchasing value by product category.

The analysis identified significant differences in supplier fulfilment rates and showed that a relatively small group of suppliers accounts for a substantial share of outstanding purchasing value.

It also demonstrated how procurement activity can be analysed from both operational and financial perspectives.

The results provide a foundation for the next phase: **Accounts Payable Analysis**, which will focus on supplier invoices, payment activity, outstanding liabilities, and payment timeliness.
