# E-Commerce Sales Trends & Forecasting Analysis

## Background and Overview

This project analyzes e-commerce sales data from an Indian online fashion retailer. 

### Business Problem 
The company needs to understand historical sales patterns to identify sales trends and seasonal patterns. Without clear visibility into sales trends, the business risks overstocking slow-moving items or running out of popular products.

### My Goal 
Analyze 163,000+ transactions to identify sales trends, seasonal patterns, and create a 6-month sales forecast to support data-driven inventory decisions.

### Tools Used 
Excel (data exploration), SQL (data cleaning and transformation), Tableau (visualization and dashboards)

---

## Data Structure Overview

![ERD](documentation/ERD01.jpg)

The dataset consists of 3 interconnected tables:

- **International Sales** (`internationalSales`): ~37K international transactions (June 2021 - March 2022)
- **Amazon Sales** (`amazonSales`): ~129K transactions from Amazon marketplace (March 2022 - June 2022)
- **Product Master** (`productMaster`): Product catalog including SKU, category, size, color, and stock levels


*Note: Original dataset included 7 files. After data quality assessment, 
4 files were excluded: 2 pricing files (duplicates with inconsistent 
dates), 1 contract document, and 1 expense report. Analysis focuses on 
transactional sales data.*

For detailed SQL queries and data transformation steps, see the [Technical Documentation](sql/).

---

## Caveats and Assumptions

### Temporal Coverage & Channel Overlap

**Date Ranges:**
- International Sales: June 2021 - March 2022 (10 months)
- Amazon Sales: March 2022 - June 2022 (4 months)
- **Overlap:** One day only (March 31, 2022)

**Root Cause:** Data cleaning removed April-May 2022 International Sales due to 
missing SKU values (corrupted data segments identified during initial cleaning).

**Impact:** Direct channel comparison not feasible due to minimal temporal overlap. 
Analysis focused on overall trends, seasonality, and category performance.

### Data Structure Challenges

**Schema Differences:**
The two sales channels have different data structures:
- Amazon includes: Order ID, fulfillment method, B2B flag, detailed shipping info
- International includes: Customer name, but lacks order-level identifiers

**Approach:** Created a unified sales view focusing on common fields (SKU, Date, 
Quantity, Amount, Channel) to enable time-series analysis. Channel-specific analyses were performed separately where detailed fields were needed.

**International Sales Data Structure:**
The original International Sales CSV contained corrupted data segments 
due to improper merging of multiple data sources. The file included:
- Rows 1-18,636: Valid sales transactions
- Rows 18,637-18,661: Orphaned SKU list (removed)
- Rows 18,662-19,676: Inventory stock data (removed)  
- Rows 19,677+: Additional sales transactions with reordered columns 
  (Restructured to match original schema)

Additionally, the two valid segments of the International Sales CSV contained slightly
different schemas. Segment 1 included a Size column whereas Segment 4 did not. Segment 4
included a Stock column whereas Segment 1 did not. 

**Cleaning approach:** Isolated valid transaction segments, standardized 
column structure, and removed non-transactional data. Final cleaned 
dataset still contains ~36,000 international sales transactions.

**Standardization approach:** Focused on core transactional fields common 
to both sources (Date, Customer, SKU, Quantity, Amount). Product size and Stock can 
be retrieved by joining to Product Master via SKU when needed. 

### Category Analysis Data Completeness

**Missing SKU Analysis:** ~4.7% of sales lack matching SKUs in Product Master
- 674 unique SKUs (legitimate product codes)
- Concentrated in Amazon channel (April-June 2022)
- Likely represents new products added after Product Master catalog snapshot
- Excluded from category-level analysis; overall trends unaffected
- 95.3% of sales successfully categorized
  
### Data Quality

- **Missing Order IDs**: International sales lack order identifiers, preventing 
  order-level analysis for that channel
- **Date Range**: 6/5/2021 - 6/29/2022
- **Currency**: All sales listed as INR in Amazon Sales dataset. Currency not listed in International Sales CSV. Assumed INR.

---

## Technical Documentation

For detailed technical implementation:
- **SQL Scripts:** See [sql/](sql/) folder for data cleaning and transformation queries
- **Data Dictionary:** See [documentation/data_dictionary.md](documentation/data_dictionary.md)  
- **ERD:** See [documentation/ERD.jpg](documentation/ERD01.jpg)

---

**Project Status:** In Progress

**Next Steps:**
- [X] Download and explore data
- [X] Create ERD
- [X] Write SQL cleaning scripts
- [ ] Build Tableau dashboard
- [ ] Complete analysis and insights
- [ ] Finalize recommendations

---

**Connect with me:** [LinkedIn](linkedin.com/in/kylimcqueen) | [kylimcqueen@gmail.com](mailto:kylimcqueen@gmail.com)






