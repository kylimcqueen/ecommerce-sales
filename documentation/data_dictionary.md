# Data Dictionary

This document defines all columns used in the geographic analysis of Amazon sales data.

---

## Amazon Sales (`amazonSales`)

Transaction-level data from Amazon marketplace sales channel (March 2022 - June 2022).

| Column Name | Data Type | Description | Example Values | Notes |
|-------------|-----------|-------------|----------------|-------|
| `Order ID` | VARCHAR | Unique identifier for each order | "405-8078469-5748320" | Primary key |
| `Date` | DATE | Date the order was placed | "2022-03-31" | Format: YYYY-MM-DD |
| `Status` | VARCHAR | Current status of the order | "Cancelled", "Shipped" | Multiple status values possible |
| `Style` | VARCHAR | Product style code/identifier | "JNE3781" | Links to product catalog |
| `SKU` | VARCHAR | Stock Keeping Unit identifier | "JNE3781-KR-L" | Foreign key to Product Master |
| `Category` | VARCHAR | Product category | "kurta", "Set" | General product classification |
| `Size` | VARCHAR | Size of the item ordered | "L", "M", "XL", "XXL", "3XL", "S", "XS", "FREE" | Apparel sizing |
| `Qty` | INTEGER | Quantity of items ordered | 1, 2, 3 | Number of units per order |
| `currency` | VARCHAR | Currency code | "INR" | All transactions in Indian Rupees |
| `Amount` | DECIMAL | Total transaction amount | 474.00, 1095.00 | Transaction value in INR |
| `ship-city` | VARCHAR | City where order is shipped | "BENGALURU", "HYDERABAD" | Customer location (city) |
| `ship-state` | VARCHAR | State where order is shipped | "KARNATAKA", "MAHARASHTRA" | Customer location (state) |
| `ship-postal-code` | VARCHAR | Postal code of shipping address | "560037", "400072" | Indian postal codes |
| `ship-country` | VARCHAR | Country of shipping address | "IN" | All values are "IN" (India) |
| `promotion-ids` | VARCHAR | Promotional campaign identifiers | "IN Core Free Shipping" | Marketing promotion applied |
| `B2B` | BOOLEAN | Business-to-business transaction flag | TRUE, FALSE | Indicates if customer is business |

**Record Count:** ~129,000 transactions

**Date Range:** March 31, 2022 - June 29, 2022

---

## Product Master (`productMaster`)

Product catalog containing details for all SKUs available for sale.

| Column Name | Data Type | Description | Example Values | Notes |
|-------------|-----------|-------------|----------------|-------|
| `index` | INTEGER | Row identifier | 0, 1, 2, 3 | Auto-generated sequential number |
| `SKU Code` | VARCHAR | Stock Keeping Unit identifier | "JNE3781-KR-L" | Primary key; links to Amazon Sales |
| `Design No` | VARCHAR | Design identifier/style number | "JNE3781" | Groups variations of same design |
| `Stock` | INTEGER | Current inventory level | 24, 0, 15 | Number of units available |
| `Category` | VARCHAR | Product category classification | "Kurta", "Set", "Top", "Western Dress" | Main product type |
| `Size` | VARCHAR | Size specification | "L", "M", "XL", "XXL", "3XL", "S", "XS", "FREE" | Apparel sizing |
| `Color` | VARCHAR | Color of the product | "Red", "Blue", "Black", "Rust" | Primary product color |

**Record Count:** Product catalog snapshot (exact count varies)

**Catalog Date:** Snapshot taken at time of data extraction; may not include all SKUs from sales data

---

## Table Relationships

```
productMaster (SKU Code) ──→ amazonSales (SKU)
                 1:N relationship
```

- **One-to-Many:** Each product SKU in the Product Master can appear in multiple Amazon Sales transactions
- **Join Key:** `productMaster.SKU Code` = `amazonSales.SKU`
- **Data Quality Note:** ~5% of Amazon Sales records have SKUs not present in Product Master (likely newer products added after catalog snapshot)

---

## Notes on Data Quality

### Missing Values
- **Amazon Sales:** No missing values in geographic fields (`ship-city`, `ship-state`)
- **Product Master:** All SKU records have complete category and size information

### Data Standardization
- All city and state names in uppercase
- Currency values stored as decimal with 2 decimal places
- Dates stored in ISO format (YYYY-MM-DD)

### Known Issues
- ~5% of sales transactions reference SKUs not in Product Master
- Product Master represents a point-in-time snapshot and may not reflect all historical or current SKUs

For detailed data quality decisions and cleaning process, see [dataQualityNotes.md](dataQualityNotes.md).
