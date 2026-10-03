# 📊 Southern Africa Retail Analytics Pipeline & Dashboard

An end-to-end data engineering and analytics project designed to ingest, clean, aggregate, and visualize retail sales transactions for a **fictional Southern African retail enterprise** operating across five regional markets. This repository showcases a robust, code-driven workflow transitioning data from raw ingestion in **Python (Pandas/SQLAlchemy)** to relational modeling in **MySQL**, and finally to interactive executive reporting in **Tableau Public**.

---

## 🚀 Project Overview

Managing retail transactional data across multiple regional environments frequently introduces challenges such as messy text formatting, conflicting timestamp structures, and inconsistent currency representations. This project implements a fully reproducible, automated pipeline to resolve these data quality issues:
* **Fictional Retail Context:** Processes a simulated multi-country retail dataset designed to mimic real-world emerging market supply chain and transaction dynamics.
* **Python & Pandas Automation:** Handles file ingestion via `ingest_and_clean.py`, text standardization, multi-format date parsing, and missing value imputation, followed by database loading via `load_data_to_mysql.py`.
* **MySQL Database Engine:** Loads the cleaned dataset into a normalized relational schema (`cleaned_retail_sales`) within MySQL Workbench for structured querying.
* **Tableau Public Visualizations:** Connects to the structured data model to deliver high-impact executive dashboards featuring global category filters, temporal trend analysis, and regional revenue share breakdowns.

---

## 📂 Repository Structure

```text
southern-africa-retail-analytics/
│
├── data/
│   ├── messy_retail_sales_dataset.csv   # Raw, unprocessed input dataset featuring text & date irregularities
│   └── cleaned_retail_sales.csv         # Fully cleaned and standardized dataset output
│
├── python/
│   ├── ingest_and_clean.py          # Handles raw data ingestion, text standardization, and cleaning logic
│   └── load_data_to_mysql.py        # Handles database connection and loading cleaned data into MySQL Workbench
│
├── sql/
│   ├── aggregation_queries.sql          # Core business metrics & analytical SQL queries
│   ├── cleaned_retail_sales_summary.sql # Summary and KPI rollup queries
│   └── retail_sales_cleaned.sql         # Table creation and data loading DDL scripts
│
├── dashboard/
│   ├── revenue_by_country.png                       # Chart export: Regional revenue breakdown
│   ├── revenue_by_country_per_product_category.png  # Chart export: Country vs product category analysis
│   ├── revenue_by_product_category.png              # Chart export: Product category performance
│   ├── sales_trend_over_time.png                    # Chart export: Temporal sales progression
│   ├── southern_africa_retail_performance_&_regional_insights.png # Main dashboard preview image
│   └── southern_african_retail_analytics.twbx       # Packaged Tableau workbook file
│
└── README.md                        # Comprehensive project documentation