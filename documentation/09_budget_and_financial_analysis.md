# 09. Budget & Financial Analysis

## Overview

This phase analyzes budget allocation and procurement spending using the synthetic procurement dataset stored in BigQuery.

The objective is to compare planned monthly budgets with the value of invoiced purchases, evaluate budget utilization, identify spending patterns across product categories, and monitor potential budget overruns.

The analysis covers the period from **1 January 2025 to 31 October 2026**, representing 22 months and 26 product categories.

The analysis uses the following tables:

- `budgets`
- `supplier_invoices`
- `supplier_invoice_lines`
- `purchase_order_items`

### Financial Metric Definition

Actual procurement spending is calculated using `supplier_invoice_lines.line_amount`.

This measure represents the value of invoiced purchase order items rather than cash payments or the full value of purchase orders.

The category is obtained from `purchase_order_items.category`, while the reporting month is based on `supplier_invoices.invoice_date`.

This approach allows invoice values to be allocated to product categories and compared with the corresponding monthly budgets.

---

## 09.1 Monthly Budget Overview

**Purpose**

This query provides an overview of monthly budget allocations and evaluates their distribution across product categories.

**Key metrics**

- Total monthly budget
- Number of categories covered
- Average category budget
- Minimum category budget
- Maximum category budget

**Methodology**

The `budgets` table is grouped by `month_start`.

The query calculates the total budget for each month, the number of distinct categories, and the average, minimum, and maximum budget allocations.

**Key findings**

- The dataset contains 22 months of budget records.
- All 26 product categories are represented in every month.
- The total number of budget records is 572.
- April 2026 recorded the highest monthly budget at **$459,087**.
- March 2026 recorded the lowest monthly budget at **$322,799**.
- The average monthly budget was approximately **$395,582**.

**Business interpretation**

The budget structure is complete and consistent across the analyzed period.

Every month contains budget allocations for all 26 categories, which allows monthly and category-level comparisons without missing budget records.

The monthly budget values vary over time, indicating that planned allocations are not fixed and differ depending on the reporting period.

---

## 09.2 Actual Procurement Spending by Month and Category

**Purpose**

This query calculates the actual value of invoiced purchases by month and product category.

**Key metrics**

- Number of invoices
- Total invoiced quantity
- Actual procurement spending

**Methodology**

The query joins `supplier_invoices`, `supplier_invoice_lines`, and `purchase_order_items`.

The invoice date determines the reporting month, while the product category is obtained from the purchase order item.

The query aggregates invoiced quantities and line amounts for each month and category.

Only invoices issued between January 2025 and October 2026 are included.

**Key findings**

- Invoiced procurement activity is distributed across multiple product categories and months.
- The number of invoices and invoiced quantities varies by category.
- Some categories have no recorded purchases in particular months.
- The total invoiced procurement spending across the analyzed period amounted to **$233,101.41**.

**Business interpretation**

The results provide a detailed view of procurement activity and show how invoiced purchases are distributed across product categories.

The analysis also establishes the actual spending dataset required for subsequent budget comparisons.

Using invoice line amounts rather than invoice header amounts allows spending to be attributed to individual product categories.

---

## 09.3 Budget vs Actual Procurement Spending

**Purpose**

This query compares monthly budget allocations with actual procurement spending for each product category.

**Key metrics**

- Budget amount
- Actual spending
- Remaining budget
- Budget utilization percentage

**Methodology**

Monthly actual spending is aggregated by invoice month and product category.

The resulting dataset is joined to the `budgets` table using both `month_start` and `category`.

A `LEFT JOIN` is used to preserve all budget records, including categories and months without recorded purchases.

The following calculations are applied:

- Remaining budget = Budget amount − Actual spending
- Budget utilization = Actual spending / Budget amount × 100

**Key findings**

- No category exceeded its allocated budget.
- The highest observed monthly category utilization was **19.94%**, recorded by Suits & Sport Coats in January 2025.
- Dresses recorded the highest utilization in February 2025 at **13.94%**.
- Multiple categories had no recorded invoiced purchases in individual months.
- Actual spending was substantially lower than the allocated budgets.

**Business interpretation**

The comparison indicates that recorded procurement spending remained below planned budget allocations throughout the analyzed period.

The results provide a basis for monitoring budget utilization and identifying categories with relatively high spending.

However, the low utilization levels should not automatically be interpreted as evidence of strong financial efficiency or cost savings.

The synthetic procurement dataset contains substantially lower spending values than the budget allocations, which may affect the comparability of these measures.

---

## 09.4 Budget Utilization by Category

**Purpose**

This query evaluates total budget utilization across product categories over the entire reporting period.

**Key metrics**

- Total budget by category
- Total actual spending
- Remaining budget
- Budget utilization percentage

**Methodology**

Budget allocations are aggregated by category across all 22 months.

Actual procurement spending is independently aggregated by category using invoice line amounts.

The two datasets are joined by category.

Budget utilization is calculated using total spending divided by total budget, rather than averaging monthly utilization percentages.

**Key findings**

- Suits & Sport Coats recorded the highest budget utilization at **6.78%**.
- Jumpsuits & Rompers ranked second at **6.60%**.
- Sweaters ranked third at **6.31%**.
- Suits & Sport Coats also recorded the highest total actual spending at **$25,253.39**.
- Shorts recorded the lowest budget utilization at **0.48%**.
- No category exceeded its total allocated budget.

**Business interpretation**

The results identify categories with relatively higher procurement spending compared with their allocated budgets.

Suits & Sport Coats represents the category with the highest utilization and the highest invoiced spending value.

However, all categories remained substantially below their allocated budgets.

The analysis can support category-level budget monitoring and help identify differences in spending patterns across product groups.

---

## 09.5 Monthly Budget Utilization

**Purpose**

This query evaluates budget utilization over time by comparing total monthly budget allocations with actual procurement spending.

**Key metrics**

- Total monthly budget
- Actual monthly spending
- Remaining budget
- Monthly budget utilization percentage

**Methodology**

Actual procurement spending is aggregated by invoice month.

Monthly budget allocations are independently aggregated from the `budgets` table.

The two datasets are joined by `month_start`.

The query calculates the remaining budget and the percentage of the monthly budget utilized.

**Key findings**

- July 2025 recorded the highest monthly utilization at **4.33%**.
- January 2025 recorded the lowest utilization at **1.13%**.
- July 2025 also recorded the highest monthly procurement spending at **$17,276.74**.
- April 2026 recorded the highest monthly budget at **$459,087**.
- No month recorded spending above its allocated budget.
- Monthly utilization varied over time without a consistent upward or downward pattern.

**Business interpretation**

The results show differences in procurement spending relative to monthly budget allocations.

July 2025 stands out as the month with the highest spending and budget utilization.

However, the analysis does not indicate a sustained increase or decrease in budget utilization over the reporting period.

Monthly monitoring can support financial planning by identifying periods with relatively higher procurement activity.

---

## 09.6 Budget Monitoring & Variance Analysis

**Purpose**

This query classifies monthly category-level budget utilization into predefined monitoring groups.

The objective is to provide a summarized view of budget consumption and identify potential budget overruns or high-utilization categories.

**Budget status classification**

The following thresholds are applied:

- `over budget` – utilization above 100%.
- `high utilization` – utilization between 80% and 100%.
- `moderate utilization` – utilization between 50% and 80%.
- `low utilization` – utilization below 50%.

These thresholds are analytical assumptions used for the portfolio project rather than predefined company financial policies.

**Key metrics**

- Number of category-month observations
- Total budget
- Actual spending
- Remaining budget
- Average utilization percentage

**Key findings**

All 572 category-month observations were classified as `low utilization`.

| Metric | Result |
|---|---:|
| Category-month observations | 572 |
| Total budget | $8,702,809.00 |
| Actual spending | $233,101.41 |
| Remaining budget | $8,469,707.59 |
| Average utilization | 3.15% |

- No observations reached the 50% utilization threshold.
- No high-utilization or over-budget cases were identified.
- All monthly category-level observations remained below 50% utilization.

**Business interpretation**

The classification indicates that procurement spending was consistently low relative to the allocated budgets.

The absence of high-utilization and over-budget observations is consistent with the results of the previous queries.

However, this result also highlights a limitation of the synthetic dataset: the scale of budget allocations is substantially higher than the recorded procurement spending.

The classification should therefore be interpreted as a property of the generated dataset rather than proof of effective financial control.

---

## Overall Conclusions

The Budget & Financial Analysis phase provides an overview of planned budget allocations and their relationship with recorded procurement spending.

The main findings are:

1. **Complete budget coverage:** All 26 product categories have budget allocations for each of the 22 analyzed months.
2. **Total budget:** The cumulative allocated budget amounted to **$8,702,809.00**.
3. **Actual procurement spending:** The total value of invoiced purchases amounted to **$233,101.41**.
4. **Overall budget utilization:** Actual spending represented approximately **2.68%** of the total allocated budget.
5. **Category-level differences:** Suits & Sport Coats recorded the highest utilization at 6.78%.
6. **Monthly differences:** July 2025 recorded the highest monthly utilization at 4.33%.
7. **Budget monitoring:** All 572 category-month observations were classified as low utilization, with no budget overruns.

### Data Limitations

The analysis is based on a synthetic dataset and should be treated as a portfolio demonstration rather than a representation of actual company financial performance.

Important limitations include:

- Budget allocations and procurement records are synthetically generated.
- Budget values are substantially higher than recorded procurement spending.
- The dataset may not represent a complete procurement cycle or all company expenses.
- Invoiced purchase values do not necessarily represent cash payments.
- Invoice line amounts are used as a proxy for procurement spending and are not independently verified accounting expenses.
- The analysis does not include operating expenses, payroll, taxes, or other financial cost categories.
- Low budget utilization does not necessarily indicate savings or operational efficiency.
- The budget monitoring thresholds are predefined analytical assumptions.

The results demonstrate SQL-based financial reporting, budget-to-actual comparisons, aggregation across reporting periods, variance analysis, and the interpretation of financial KPIs.
