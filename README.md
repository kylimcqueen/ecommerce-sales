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

### Data Source & Scope
- Public Kaggle dataset; company name anonymized
- Analysis period: June 2021 - June 2022 (13 months)
- 163,000+ transactions across two sales channels

### Temporal Coverage
- **International Sales:** June 2021 - March 2022 (10 months, 34K transactions)
- **Amazon Sales:** March 2022 - June 2022 (4 months, 129K transactions)
- **Minimal overlap** (1 day) prevents direct channel comparison
- Root cause: April-May 2022 International data removed during cleaning due to 
  corrupted file segments with missing SKU values

### Data Completeness
- **Category Analysis:** ~5% of sales lack matching SKU in Product Master 
  (likely new products added after catalog snapshot); excluded from category 
  analysis
- **Currency:** All values assumed INR
- **Schema Differences:** Channels have different data structures; unified 
  on common fields (Date, SKU, Quantity, Amount)

### Analysis Focus
Given data limitations, analysis focuses on:
- Overall sales trends (13-month view)
- Seasonal patterns (aggregated across channels)
- Category performance (95% coverage)

*For detailed data quality assessment and cleaning decisions, see 
[Data Quality Notes](documentation/data_quality_notes.md)*
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






