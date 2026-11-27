# Business Operations & Financial Analysis

## Project Overview

This project focuses on comprehensive financial and operational analysis of a business using SQL, Google BigQuery, and Power BI.

The main objective was to transform raw business data into structured analytical datasets, build a relational data model, and develop interactive dashboards to monitor key areas of business performance.

The project covers five main analytical areas: sales performance, procurement processes, accounts payable, budget management, and inventory and product performance.

It demonstrates an end-to-end analytical workflow — from data exploration and preparation, through SQL-based analysis and data modeling, to the development of DAX measures and Business Intelligence reports.

## Business Objectives

The main objectives of the project were to:

- Analyze sales performance and order trends.
- Evaluate procurement processes and supplier performance.
- Monitor supplier invoices, payments, and outstanding liabilities.
- Compare allocated budgets with actual spending.
- Analyze inventory characteristics and product sales performance.
- Develop interactive dashboards to support business performance monitoring and data-driven decision-making.

## Technologies & Tools

| Technology | Application |
|---|---|
| Google BigQuery | Cloud data warehouse and SQL analysis |
| SQL | Data exploration, transformation, preparation, and analytical queries |
| Power BI | Data modeling and interactive dashboard development |
| DAX | Creation of measures, KPIs, and business calculations |
| Power Query | Data preparation and transformation in Power BI |

## Data Sources

The project uses data from two different sources.

**1. TheLook E-commerce Dataset**

A public dataset representing an e-commerce business, containing information about:

- Orders.
- Order items.
- Products.
- Inventory items.

**2. Synthetic Procurement and Financial Data**

Additional datasets created for this project to simulate the procurement and financial processes of a business:

- Suppliers.
- Purchase orders.
- Purchase order items.
- Goods receipts.
- Supplier invoices.
- Supplier invoice lines.
- Supplier payments.
- Budgets.

Combining these two sources makes it possible to analyze several interconnected areas of business operations.

## Project Workflow

### 1. Data Exploration

- Explored the available datasets and their structures.
- Reviewed columns, data types, and relationships between tables.
- Identified variables relevant to business analysis.
- Assessed data completeness and consistency.

### 2. Data Preparation & Transformation

- Used SQL in BigQuery to prepare analytical datasets.
- Standardized data structures and column types where necessary.
- Selected columns relevant to further analysis.
- Prepared datasets for integration into Power BI.

### 3. SQL Analysis

Conducted analyses covering:

- Sales performance and order activity.
- Purchase values and purchasing patterns.
- Supplier activity.
- Supplier invoices and payments.
- Budget allocation and spending.
- Product characteristics and inventory.

### 4. Data Modeling

Built a relational data model in Power BI.

The model integrates e-commerce, procurement, and financial data using relationships between relevant business entities.

Created shared dimension tables, including:

- Calendar.
- Categories.

The model enables cross-functional analysis and interactive filtering across reports.

### 5. DAX Measures & KPI Development

Developed DAX measures to calculate key business metrics, including:

- Sales value.
- Number of orders.
- Average order value.
- Purchase value.
- Number of purchase orders.
- Invoice value.
- Total payments.
- Outstanding liabilities.
- Budget utilization.
- Number of inventory items.
- Inventory sell-through rate.

### 6. Dashboard Development

Developed five interactive Power BI dashboards covering the main areas of business operations.

## Dashboards

### 1. Sales Performance

This dashboard focuses on e-commerce sales analysis and order performance.

![Sales Performance Dashboard](https://github.com/user-attachments/assets/bbb8acaf-9f4c-4da0-8026-f8b3da100f1a)

**Key analytical areas:**

- Total sales value.
- Number of orders.
- Average order value.
- Average selling price.
- Number of completed orders.
- Order completion rate.
- Monthly sales trends.
- Sales by product category.
- Sales by order status.

### 2. Procurement Performance

This dashboard provides insights into the company's purchasing activity and supplier performance.

![Procurement Performance Dashboard](https://github.com/user-attachments/assets/9e87c3a7-979b-445b-845a-c4c7ae603c05)

**Key analytical areas:**

- Total purchase value.
- Number of purchase orders.
- Number of suppliers.
- Average purchase order value.
- Ordered quantity.
- Received quantity.
- Monthly purchase value.
- Purchase value by category.
- Top suppliers by purchase value.
- Purchase orders by status.

### 3. Accounts Payable

This dashboard focuses on supplier invoices and payment activity.

![Accounts Payable Dashboard](https://github.com/user-attachments/assets/50d9d66c-5529-4701-8927-37bbdc846155)

**Key analytical areas:**

- Total invoice value.
- Number of invoices.
- Total payments.
- Outstanding liabilities.
- Average invoice value.
- Monthly invoice value and payments.
- Outstanding amounts by supplier.
- Invoice value by supplier.
- Invoice value by due date.

### 4. Budget Performance

This dashboard analyzes budget allocation and spending across different categories and periods.

![Budget Performance Dashboard](https://github.com/user-attachments/assets/95c9fe90-3a6e-429f-a888-0ea88f9a4814)

**Key analytical areas:**

- Total budget.
- Actual spending.
- Remaining budget.
- Budget utilization percentage.
- Monthly budget vs. actual spending.
- Budget allocation by category.
- Actual spending by category.
- Budget utilization by category.

### 5. Inventory & Product Performance

This dashboard combines inventory data with product sales analysis.

![Inventory & Product Performance Dashboard](https://github.com/user-attachments/assets/d7aae11c-2f95-4563-b17d-6e42e0566388)

**Key analytical areas:**

- Total inventory items.
- Number of unique products.
- Number of sold inventory items.
- Number of unsold inventory items.
- Inventory sell-through rate.
- Inventory distribution by category.
- Top 10 products by sales value.
- Sold vs. unsold inventory items.
- Monthly sales trends.

## Analytical Assumptions & Limitations

Several important considerations were taken into account when interpreting the results:

- E-commerce and procurement/financial datasets originate from different sources and have different structures and business contexts.
- Procurement and financial datasets are synthetic and should therefore be interpreted as a simulation of business processes.
- Purchase order values, invoice values, and payment amounts represent different stages of the procurement and payment processes.
- Actual spending is calculated based on supplier invoice line amounts, rather than payments made.
- Budget utilization represents the relationship between recorded invoice-based spending and allocated budgets.
- Inventory records without a `sold_at` date are treated as unsold records, not as confirmed current stock levels.
- Inventory data may not represent the actual stock available at a specific point in time.
- Order statuses are interpreted according to the definitions provided in the source dataset.

These limitations are important when interpreting KPIs and drawing business conclusions.

## Repository Structure

```text
business-operations-financial-analytics/
│
├── sql/
│   ├── 01_data_exploration.sql
│   ├── 02_data_quality_checks.sql
│   ├── 03_order_status_analysis.sql
│   ├── 04_sales_analysis.sql
│   ├── 05_inventory_analysis.sql
│   ├── 06_procurement_and_accounts_payable_dataset.sql
│   ├── 07_procurement_analysis.sql
│   ├── 08_accounts_payable_analysis.sql
│   └── 09_budget_and_financial_analysis.sql
│
├── power_bi/
│   ├── business_operations_analytics.pbix
│   └── screenshots/
│       ├── sales_performance.png
│       ├── procurement_performance.png
│       ├── accounts_payable.png
│       ├── budget_performance.png
│       └── inventory_product_performance.png
│
├── documentation/
│   ├── 01_data_overview.md
│   ├── 02_data_quality_report.md
│   ├── 03_order_analysis.md
│   ├── 04_sales_analysis.md
│   ├── 05_inventory_analysis.md
│   ├── 06_procurement_and_accounts_payable_dataset.md
│   ├── 07_procurement_analysis.md
│   ├── 08_accounts_payable_analysis.md
│   └── 09_budget_and_financial_analysis.md
│
├── README.md
└── README_PL.md
```
