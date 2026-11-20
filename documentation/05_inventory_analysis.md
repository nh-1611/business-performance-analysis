# 05. Inventory Analysis

## 1. Objective

The objective of this analysis is to evaluate inventory structure, identify products with the highest number of unsold units, examine inventory aging, and estimate the cost value of unsold inventory.

The analysis focuses on:
- Inventory volume and sales status.
- Inventory distribution across product categories.
- Products with the highest number of unsold units.
- Inventory aging based on record creation and sale dates.
- Estimated inventory value based on product costs.

## 2. Data Sources

The analysis uses two tables from the `thelook_ecommerce` dataset:

- `inventory_items` – individual inventory units, including product identifiers, creation dates, and sale dates.
- `products` – product information, including category and unit cost.

The tables are joined using `inventory_items.product_id = products.id`.

**Data grain:** One row in `inventory_items` represents one physical inventory unit.

## 3. SQL Analysis

### 3.1 Inventory Overview

**Objective:** Evaluate the overall inventory structure by identifying the number of total, sold, and unsold units.

**Key metrics:**
- `total_inventory_items` – total number of inventory records.
- `sold_items` – units with a recorded sale date (`sold_at IS NOT NULL`).
- `unsold_items` – units without a recorded sale date (`sold_at IS NULL`).
- `sold_items_percentage` – percentage of sold units.
- `unsold_items_percentage` – percentage of unsold units.

**Key findings:**

The dataset contains 489,068 inventory units:
- 181,205 units (37.05%) have a recorded sale date.
- 307,863 units (62.95%) have no recorded sale date.

The majority of inventory records represent units without a recorded sale date.

### 3.2 Inventory by Product Category

**Objective:** Analyze inventory distribution across product categories and compare the proportion of sold and unsold units.

**Methodology:**

Inventory records were joined with the products table and grouped by product category. The number and percentage of sold and unsold units were calculated for each category.

**Key findings:**
- Intimates has the highest number of inventory units (36,471).
- Jeans (34,543) and Tops & Tees (32,585) also represent substantial inventory volumes.
- Suits has the highest sold percentage (37.45%).
- Underwear has the lowest sold percentage (36.77%).
- Differences in sold percentages across categories are relatively small.

The results indicate that categories differ mainly in inventory volume rather than in the proportion of sold units.

### 3.3 Inventory by Product

**Objective:** Identify individual products with the highest number of unsold inventory units.

**Methodology:**

Inventory units were grouped by product, and the number of total, sold, and unsold units was calculated. The results were sorted by the number of unsold units in descending order.

**Key findings:**
- Oak Hill Big & Tall Zip Mockneck Cardigan has the highest number of unsold units (36).
- C-IN2 Men's Filthy Lo No Show Brief follows with 35 unsold units.
- RVCA Men's Puffer Chambray Long Sleeve Hooded Jacket and JM Skinz Thong have the highest unsold percentage in the top 10 (68.09%).

The analysis identifies products that may require further inventory monitoring. However, a high number of unsold units does not necessarily indicate excess inventory, as the initial stock volume may also be higher.

### 3.4 Inventory Aging Analysis

**Objective:** Examine how long inventory units remain without a recorded sale date.

**Methodology:**

The number of days between `created_at` and `sold_at` was calculated for sold units. For unsold units, the reference date of November 19, 2026, was used.

Inventory units were divided into five aging groups:
- 0–30 days
- 31–60 days
- 61–90 days
- 91–180 days
- Over 180 days

**Key findings:**
- 285,633 units fall into the over-180-days group.
- All units in the 61–90, 91–180, and over-180-days groups have no recorded sale date.
- The dataset shows a clear distinction between units created within the first 60 days and older unsold units.

This pattern may reflect the way the synthetic dataset was generated rather than actual inventory turnover.

### 3.5 Inventory Value

**Objective:** Estimate the cost value of inventory units with and without a recorded sale date.

**Methodology:**

Inventory records were joined with the products table. The unit cost (`products.cost`) was summed across all inventory units and separately for sold and unsold units.

**Key metrics:**
- `total_inventory_value` – estimated cost value of all inventory units.
- `sold_inventory_value` – estimated cost value of units with a recorded sale date.
- `unsold_inventory_value` – estimated cost value of units without a recorded sale date.
- `unsold_inventory_value_percentage` – percentage of total inventory value represented by unsold units.

**Key findings:**
- Total estimated inventory value: approximately 13.98 million.
- Sold inventory value: 5,184,561.89.
- Unsold inventory value: 8,800,021.57.
- Unsold inventory represents 62.93% of total estimated inventory value.

The results indicate that a substantial share of the estimated inventory cost value is associated with units without a recorded sale date.

## 4. Key Business Findings

1. **High proportion of unsold units:** 62.95% of inventory records have no recorded sale date.
2. **Similar category-level proportions:** Sold percentages are relatively consistent across product categories.
3. **Product-level monitoring:** The analysis identifies individual products with relatively high numbers of unsold units.
4. **Inventory aging:** A substantial number of units fall into the over-180-days group, although the synthetic nature of the dataset limits interpretation.
5. **Estimated inventory value:** Units without a recorded sale date represent approximately 62.93% of the total estimated inventory cost value.

## 5. Data Limitations

The results should be interpreted with the following limitations:

- The dataset is synthetic and may not fully reflect real-world inventory management processes.
- `created_at` represents the creation date of an inventory record and is not necessarily the physical date of warehouse receipt.
- `sold_at IS NULL` indicates the absence of a recorded sale date, but does not independently confirm that an item is currently available in stock.
- Inventory aging is based on record creation dates and should not be interpreted as a verified measure of physical stock age.
- `products.cost` is used as an estimated unit cost, not as a verified accounting inventory valuation.
- The analysis does not include storage costs, write-downs, damaged goods, stock adjustments, or other inventory-related expenses.

## 6. Conclusion

The inventory analysis provides an overview of inventory volume, product category distribution, unsold units, inventory aging, and estimated inventory cost value.

The results identify areas that could be relevant for further inventory monitoring, particularly products and units without recorded sales over extended periods.

However, due to limitations in the dataset, the findings should be treated as exploratory estimates rather than confirmed operational or accounting measures.

The analysis provides a foundation for the next stage of the project: Procurement and Accounts Payable Analysis.
