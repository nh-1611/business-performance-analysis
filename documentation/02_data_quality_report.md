# Data Quality Report

## 1. Objective

The purpose of the initial data quality assessment was to verify the structural integrity, completeness and consistency of the selected TheLook E-commerce tables before performing business and financial analyses.

## 2. Primary key validation

The following candidate primary keys were examined:

- `products.id`
- `orders.order_id`
- `order_items.id`
- `inventory_items.id`

**Result:** No NULL or duplicate identifiers were detected in the checked columns.

These columns can therefore be treated as candidate primary keys for analytical purposes.

## 3. Foreign key validation

The following relationships were checked:

- `order_items.product_id` → `products.id`
- `order_items.order_id` → `orders.order_id`
- `order_items.inventory_item_id` → `inventory_items.id`
- `products.distribution_center_id` → `distribution_centers.id`

**Result:** No unmatched references were detected in the checked relationships.

Additional consistency checks confirmed that customer and product identifiers were consistent across related tables.

## 4. Completeness and numeric validation

The following areas were examined:

- Missing, negative and zero product costs and retail prices.
- Missing, negative and zero order item sale prices.
- Missing order and product identifiers.
- Missing order creation dates and selected order attributes.
- Missing inventory product identifiers, costs, retail prices and creation dates.
- Missing distribution center names, coordinates and geographic geometry.

**Result:** All checked conditions returned zero exceptions.

## 5. Temporal validation

Selected date relationships were examined, including:

- Shipment before order creation.
- Delivery before shipment.
- Return before order creation.
- Inventory sale before inventory item creation.

**Result:** No violations were detected in the checked conditions.

## 6. Cross-table consistency

Two additional consistency checks were performed:

**Order item count**

The value of `orders.num_of_item` was compared with the actual number of records in `order_items` for each order.

Result: No inconsistent order item counts and no orders without corresponding items.

**Sale price and retail price**

The `order_items.sale_price` field was compared with `products.retail_price`.

Result: No price differences were detected.

## 7. Inventory item uniqueness

The uniqueness of `inventory_item_id` within `order_items` was checked.

Result: No repeated inventory item identifiers were detected. A separate NULL check also returned zero missing identifiers.

## 8. Limitations

The assessment covers only the selected columns, relationships and validation rules. It does not establish that the entire source dataset is free of errors.

The dataset is synthetic, so structural consistency should not be interpreted as proof of real-world accounting accuracy.

## 9. Conclusion

The selected tables passed the performed structural, referential and consistency checks.

No issues were identified that would prevent proceeding with the planned analytical work.
