# 04. Sales Analysis

## 1. Objective

The objective of this analysis is to evaluate sales performance and estimated product profitability using the TheLook eCommerce dataset.

The analysis focuses on:
- Sales value by order status.
- Monthly sales value and Average Order Value (AOV).
- Sales performance by product category.
- Best-performing products by sales value and sales volume.
- Estimated gross profit and gross margin by product and product category.

The analysis uses four tables from the `bigquery-public-data.thelook_ecommerce` dataset:
- `orders`
- `order_items`
- `products`
- `inventory_items` (not directly required in this analysis).

### Data grain and joins

The `orders` table contains one row per order, whereas `order_items` contains one row per order item.

The tables are joined using `order_id`. Since one order can contain multiple items, order-level attributes are repeated after joining. Therefore:
- `COUNT(DISTINCT o.order_id)` is used to count unique orders.
- `COUNT(*)` is used to count order item positions.
- `SUM(oi.sale_price)` calculates the total value of the recorded order items.

The `products` table is joined using `products.id = order_items.product_id` to retrieve product names, categories and costs.

### Order status treatment

The sales performance queries (01–05) include all order statuses:
- Shipped
- Complete
- Processing
- Cancelled
- Returned

These queries analyse recorded order item values across all statuses. They do not represent confirmed accounting revenue or cash collected.

The profitability queries (06–08) include only orders with `Complete` status. This restriction provides a more consistent basis for estimating profitability from completed orders.

However, the dataset does not contain sufficient payment, refund or accounting information to confirm actual recognized revenue.

## 3. SQL Analysis

### 01. Sales Value by Order Status

**Business question:** How is recorded order value distributed across different order statuses?

The query aggregates order item sales value by order status using a Common Table Expression (CTE).

Metrics:
- `sales_value` – total recorded value of order items for each status.
- `order_count` – number of unique orders.
- `positions_count` – number of order item positions.
- `sales_value_percentage` – percentage share of each status in the total recorded order value.

A window function (`SUM() OVER()`) calculates the total sales value across all statuses and provides the denominator for the percentage calculation.

**Key observations:**
- Shipped orders accounted for the largest share of recorded order value (29.72%).
- Complete orders represented 25.10%.
- Cancelled and Returned orders together accounted for 25.14% of recorded order value.

**Business interpretation:**

The distribution highlights the importance of monitoring order statuses when evaluating sales performance. A substantial share of recorded order value is associated with cancelled and returned orders.

These values should not automatically be interpreted as financial losses or refunded revenue, as the dataset does not provide payment and refund details.

### 02. Monthly Sales Value and Average Order Value (AOV)

**Business question:** How does sales value change over time, and is this change associated with the number of orders or their average value?

The query aggregates sales data by calendar month using `DATE_TRUNC()`.

Metrics:
- `sales_value` – total recorded order item value per month.
- `order_count` – number of unique orders per month.
- `average_order_value` – average recorded value per order.

AOV is calculated as:

`AOV = Total Sales Value / Number of Unique Orders`

`COUNT(DISTINCT o.order_id)` is necessary because an order may contain multiple order item positions.

**Key observations:**
- Monthly sales value increased substantially over the analysed period.
- Monthly order count also increased.
- AOV remained relatively stable during most of the analysed period.

**Business interpretation:**

The increase in monthly sales value is largely associated with the growth in order volume rather than a substantial increase in average order value.

This indicates that the observed growth is primarily volume-driven.

The results describe patterns in the synthetic dataset and should not be interpreted as evidence of actual business growth.

### 03. Sales Value by Product Category

**Business question:** Which product categories generate the highest recorded sales value?

The query joins products, order items and orders to aggregate sales data by product category.

Metrics:
- `sales_value` – total recorded sales value per category.
- `sold_positions` – number of sold order item positions.
- `avg_item_price` – average sale price per order item position.

**Key observations:**
- Outerwear & Coats generated the highest sales value.
- Jeans ranked second in total sales value.
- Intimates recorded the highest number of sold positions.
- Outerwear & Coats had a relatively high average item price, while categories such as Intimates had a considerably lower average price.

**Business interpretation:**

Sales value depends on both sales volume and average item price.

A category with a high number of sold positions does not necessarily generate the highest sales value. Higher-priced products can generate substantial sales value even with lower sales volumes.

### 04. Top 10 Products by Sales Value

**Business question:** Which individual products generate the highest recorded sales value?

The query aggregates sales data at product level using product ID, name and category.

Metrics:
- `sales_value` – total recorded sales value per product.
- `sold_positions` – number of sold positions.

The results are sorted by sales value in descending order, with sold positions used as a secondary sorting criterion.

Only the first 10 products are returned using `LIMIT 10`.

**Business interpretation:**

This ranking identifies products generating the highest total recorded sales value.

However, high sales value does not necessarily indicate high profitability, as product costs are not considered in this query.

### 05. Top 10 Products by Sales Volume

**Business question:** Which products are sold most frequently?

The query uses the same product-level aggregation as the previous analysis, but changes the sorting criteria.

Products are ranked by:
1. `sold_positions` – descending.
2. `sales_value` – descending, as a secondary sorting criterion.

The query returns the first 10 results.

**Business interpretation:**

The ranking identifies products with the highest number of sold positions.

Comparing this ranking with the sales value ranking demonstrates that the most frequently sold products are not necessarily those generating the highest total sales value.

The difference is influenced by product prices.

### 06. Top 10 Products by Estimated Gross Profit

**Business question:** Which products generate the highest estimated gross profit?

Unlike the previous sales queries, this analysis includes only orders with `Complete` status.

Metrics:
- `sales_value` – total recorded sales value.
- `total_cost` – estimated total cost of sold products.
- `gross_profit` – estimated gross profit.
- `gross_margin_pct` – estimated gross margin percentage.
- `sold_positions` – number of sold positions.

Formulas:

`Gross Profit = Sales Value - Total Cost`

`Gross Margin (%) = (Gross Profit / Sales Value) × 100`

The `products.cost` field is treated as the unit cost of a product. Since each order item position represents one sold item, the cost is summed across all included positions.

`SAFE_DIVIDE()` is used to prevent division-by-zero errors.

Products are ranked by estimated gross profit in descending order.

**Key observations:**
- Darla generated the highest estimated gross profit in the TOP 10, amounting to 2,377.62.
- Its estimated gross margin was 59.5%.
- Products with relatively high gross margins did not necessarily generate the highest gross profit.

**Business interpretation:**

Gross profit measures the estimated monetary contribution generated after deducting product costs.

Gross margin measures the proportion of sales value retained after covering product costs.

A product can have a high gross margin but generate a lower total gross profit if its sales value or sales volume is relatively low.

### 07. Top 10 Products by Estimated Gross Margin

**Business question:** Which products have the highest estimated gross margin percentage?

The query uses the same profitability calculations and completed-order filter as the previous analysis.

The main difference is the sorting criterion: products are ranked by `gross_margin_pct` in descending order.

**Business interpretation:**

This ranking focuses on relative profitability rather than the total monetary contribution.

The results showed products with identical gross margin percentages, including multiple products from the Blazers & Jackets category.

The ranking also included products with very low sales volumes.

Consequently, high gross margin percentages should be interpreted with caution, especially when based on a small number of sold positions.

No minimum sales volume threshold was applied in this query.

### 08. Gross Profit and Gross Margin by Product Category

**Business question:** Which product categories generate the highest estimated gross profit and which have the highest gross margin?

The query aggregates profitability metrics at category level, using only orders with `Complete` status.

Metrics:
- `sales_value` – total recorded sales value.
- `total_cost` – estimated total product cost.
- `gross_profit` – estimated gross profit.
- `gross_margin_pct` – estimated gross margin percentage.
- `sold_positions` – number of sold positions.

Gross margin is calculated using total category gross profit divided by total category sales value.

This approach calculates a sales-value-weighted margin rather than a simple average of individual product margins.

**Key observations:**
- Outerwear & Coats generated the highest estimated gross profit (171,514.75).
- Blazers & Jackets recorded the highest estimated gross margin (62.13%).
- Intimates had the highest sales volume (3,116 positions), but did not generate the highest gross profit.
- Jeans generated the second-highest gross profit (139,486.23), with a gross margin of 46.50%.
- Clothing Sets recorded the lowest gross margin (38.61%).

**Business interpretation:**

The results demonstrate that the category with the highest gross profit is not necessarily the category with the highest gross margin or sales volume.

Different performance metrics provide complementary perspectives on product category performance.

Outerwear & Coats stands out in terms of total estimated gross profit, while Blazers & Jackets demonstrates the highest relative profitability.

## 4. Key Business Findings

The analysis highlights several important findings:

1. **Order status matters:** A substantial share of recorded order value is associated with cancelled and returned orders, which should be considered when evaluating sales performance.

2. **Sales growth is volume-driven:** The increase in monthly sales value is largely associated with a growing number of orders, while AOV remains relatively stable.

3. **Sales value and sales volume provide different perspectives:** Products with the highest sales value are not necessarily the most frequently sold products.

4. **Profitability differs across categories:** Outerwear & Coats generates the highest estimated gross profit, whereas Blazers & Jackets has the highest estimated gross margin.

5. **High sales volume does not guarantee high profitability:** Intimates records the highest sales volume but does not lead in gross profit.

6. **Gross profit and gross margin should be analysed together:** Gross profit measures the monetary contribution, while gross margin measures relative profitability.

## 5. Data Limitations

Several limitations should be considered when interpreting the results:

- TheLook eCommerce is a synthetic dataset. Observed trends and relationships should not be treated as evidence of actual business performance.
- Sales value represents the sum of recorded order item sale prices, not confirmed accounting revenue or cash collected.
- Sales analysis queries 01–05 include all order statuses, while profitability queries 06–08 include only `Complete` orders. Their results therefore cover different populations and should not be directly compared without aligning the filters.
- The `products.cost` field is used as an estimate of unit product cost. It has not been verified as a complete accounting COGS measure.
- Gross profit and gross margin are therefore estimates, not confirmed accounting figures.
- The dataset does not provide sufficient payment, refund or operating expense information to calculate net profit or confirm the full financial impact of returns and cancellations.
- Product-level profitability rankings may be affected by low sales volumes.

## 6. Conclusion

The sales analysis provides an overview of recorded sales performance, order activity and estimated product profitability.

It demonstrates the importance of combining sales value, sales volume, gross profit and gross margin when evaluating business performance.

The findings also provide a basis for further financial analysis, particularly procurement cost management, supplier invoice control, accounts payable monitoring and budget analysis.
