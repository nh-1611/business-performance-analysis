# Data Overview

## 1. Data source

The project uses the public **TheLook E-commerce** dataset available in Google BigQuery:

`bigquery-public-data.thelook_ecommerce`

The dataset contains synthetic e-commerce data representing customer orders, products, order items and inventory records.

## 2. Tables overview

Four primary tables were selected for the initial analysis.

| Table | Number of records | Description |
|---|---:|---|
| products | 29,120 | Product catalog |
| orders | 125,481 | Customer orders |
| order_items | 181,885 | Individual order items |
| inventory_items | 490,750 | Individual inventory units |
| **Total** | **817,236** | |

## 3. Data structure and relationships

The tables represent different levels of granularity:

- `products` – one record per product.
- `orders` – one record per customer order.
- `order_items` – one record per item within an order.
- `inventory_items` – one record per physical inventory unit.

The main relationships identified are:

- `orders.order_id` → `order_items.order_id`
- `products.id` → `order_items.product_id`
- `products.id` → `inventory_items.product_id`
- `inventory_items.id` → `order_items.inventory_item_id`

The granularity of each table was identified based on its structure, primary key candidates and relationships with other tables. This distinction is important when joining and aggregating data to prevent duplicated records and inflated metrics.

## 4. Data coverage

The order dataset covers the period from **14 January 2019 to 19 November 2026**.

A total of 95 calendar months are represented in the source data.

Incomplete periods were excluded from the analysis. January 2019 was excluded because the available data starts on 14 January 2019, while November 2026 was excluded because it is an incomplete reporting period. **The analysis therefore covers February 2019 through October 2026.**

## 5. Analytical considerations

- The source dataset is synthetic and should not be interpreted as actual company accounting data.
- The `products.cost` field is treated as a dataset-provided product cost, not verified accounting COGS.
- The `order_items.sale_price` field represents the recorded selling price of an individual order item.
- Different tables have different grains, which must be considered when joining and aggregating data.
