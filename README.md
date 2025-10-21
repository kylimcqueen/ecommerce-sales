# E-Commerce Sales Analysis: Geographic, Customer & Product Insights

## Background and Overview

This project analyzes e-commerce sales data from an Indian online fashion retailer. 

### Business Problem 
The company initially sought to understand historical sales patterns to identify trends and create forecasts. However, during data exploration and cleaning, significant data quality issues emerged that required a strategic pivot in the analysis approach.

### The Pivot: From Time-Series to Multi-Dimensional Analysis
**Original Goal:** Analyze 163,000+ transactions to identify sales trends, seasonal patterns, and create a 6-month sales forecast.

**What Changed:** After extensive data cleaning, it became clear that the two sales channels had minimal temporal overlap (1 day), making traditional time-series forecasting inappropriate. Rather than force an analysis that wouldn't yield valid insights, I pivoted to extract meaningful value from what the data *could* tell us.

**Revised Goal:** Conduct a three-pronged analysis that leverages each dataset's unique strengths:
1. **Amazon Geographic Analysis** - Where are customers located and what do they buy?
2. **International Customer Analysis** - Who are our repeat customers and what drives loyalty?
3. **Cross-Channel Product Analysis** - How does product performance differ between channels?

### Tools Used 
Excel (data exploration), SQL (data cleaning and transformation), Tableau (visualization and dashboards)

---

## Data Structure Overview

![ERD](documentation/ERD01.jpg)

The dataset consists of 3 interconnected tables:

- **International Sales** (`internationalSales`): ~34K international transactions (June 2021 - March 2022)
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

### Schema Differences:
  - Amazon: Has geographic data, lacks customer identifiers
  - International: Has customer identifiers, lacks geographic data
  - Unified on common fields where possible (Date, SKU, Quantity, Amount)

### Currency
- All values assumed INR (Indian Rupees)

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






