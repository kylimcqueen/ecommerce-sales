# E-Commerce Sales Analysis: Geographic Insights for Strategic Growth

## Executive Summary

This project analyzes e-commerce sales data from an Indian online fashion retailer, focusing on geographic distribution and regional performance patterns. When initial time-series forecasting proved inappropriate due to data quality constraints, I pivoted to geographic analysis, uncovering actionable insights about regional sales patterns across 129,000+ Amazon transactions.

### Key Findings:

- **Four states drive 60%+ of revenue**: Maharashtra, Karnataka, Telangana, and Uttar Pradesh represent the company's geographic strongholds.
- **Urban concentration**: Top 5 cities (Bengaluru, Hyderabad, Mumbai, New Delhi, Chennai) account for disproportionate sales volume while maintaining consistent average order values. 
- **Growth opportunities identified**: High-performing cities in lower-performing states (New Delhi, Kolkata, Gurugram) present expansion opportunities. 
- **Product uniformity**: Kurta and kurta sets dominate across all regions, suggesting consistent brand positioning nationwide.


**Business Impact**: These insights enable targeted marketing investments, optimized inventory distribution, and strategic expansion into high-potential markets.

---

## Background and Overview

This project analyzes e-commerce sales data from an Indian online fashion retailer to understand geographic sales patterns and identify strategic growth opportunities.

### Business Problem 
The company initially sought to understand historical sales patterns to identify trends and create forecasts. However, during data exploration and cleaning, significant data quality issues emerged that required a strategic pivot in the analysis approach.

### The Pivot: From Time-Series to Geographic Analysis
**Original Goal:** Analyze 163,000+ transactions to identify sales trends, seasonal patterns, and create a 6-month sales forecast.

**What Changed:** After extensive data cleaning, it became clear that the two sales channels had minimal temporal overlap (1 day), making traditional time-series forecasting inappropriate. Rather than force an analysis that wouldn't yield valid insights, I pivoted to extract meaningful value from what the data *could* reliably tell us.

**Revised Goal**: Conduct geographic analysis of Amazon sales channel to understand:

1. Where customers are located and regional sales distribution
2. Top-performing cities and states by sales volume
3. Whether geographic regions show preferences for specific product categories

### Tools Used 
- **Excel**: Initial data exploration and quality assessment
- **SQL**: Data cleaning, transformation and analysis queries
- **Tableau**: Interactive dashboard creation and geographic visualization

---

## Data Structure Overview

![ERD](documentation/ERD01.jpg)

The analysis focuses on Amazon sales data integrated with product catalog information:

- **Amazon Sales** (`amazonSales`): ~129K transactions from Amazon marketplace (March 2022 - June 2022)
- **Product Master** (`productMaster`): Product catalog including SKU, category, size, color, and stock levels

*Note: Original dataset included multiple sales channels. After data quality assessment, analysis focuses on Amazon sales data which provided complete geographic information necessary for regional analysis. International sales channel lacked location data and was excluded from this geographic study.
For detailed SQL queries and data transformation steps, see the Technical Documentation.*

---

## Geographic Analysis Dashboard
(image)

The interactive dashboard visualizes sales distribution across India, highlighting:

**State-level performance** with heat map visualization
**Top 10 cities** by total sales volume

*&Key Visual Insights**:

- Strong concentration in southern and western India (Karnataka, Maharashtra, Telangana)
- Urban metros dominate sales volume despite similar order values

---
## Geographic Insights

### Business Question 1: Where are our Amazon customers located?

**State-Level Performance:
The highest total sales concentrate in four states: Maharashtra, Karnataka, Telangana, and Uttar Pradesh. These states represent the company's geographic strongholds and account for the majority of Amazon channel revenue.
Uttar Pradesh Pattern: While Uttar Pradesh ranks as the fourth highest-performing state, its sales pattern differs from the top three. The top three states each have one dominant city driving sales, but Uttar Pradesh's performance is distributed across three cities (ranked 10th, 11th, and 12th nationally). This suggests a more geographically distributed customer base within the state.

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
- [X] Build Tableau dashboard
- [ ] Complete analysis and insights
- [ ] Finalize recommendations

---

**Connect with me:** [LinkedIn](linkedin.com/in/kylimcqueen) | [kylimcqueen@gmail.com](mailto:kylimcqueen@gmail.com)






