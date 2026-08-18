# Azure Data Pipeline

An end-to-end data engineering project built on Azure, moving on-premises Sales CRM data through a full Medallion Architecture (Bronze → Silver → Gold) into a business-ready reporting layer.

## Overview

This project simulates a real-world scenario: on-premises CRM data (accounts, products, sales pipeline, sales teams) is ingested into Azure, cleaned and validated through a custom Data Quality Gate, transformed into business-ready Gold tables, and surfaced through both SQL querying and an interactive Power BI dashboard.

## Architecture

<img width="1692" height="929" alt="ChatGPT Image Aug 18, 2026, 03_07_50 PM" src="https://github.com/user-attachments/assets/22579425-ca48-471b-8255-ed67d385308c" />

## Tech Stack

- **Azure Data Factory** — ingestion & orchestration
- **Azure Data Lake Storage Gen2** — central storage layer
- **Azure Databricks** (PySpark, Unity Catalog) — data processing
- **Azure Synapse Analytics** — serverless SQL querying
- **Power BI** — reporting & visualization
- **Azure Logic Apps · Azure Monitor · Azure Key Vault** — reliability, monitoring, and security
- **Git / GitHub** — version control

## Pipeline Components

🔹 **Azure Data Factory** — ingests on-premises CSV files using a Self-Hosted Integration Runtime, with Git integration, scheduled triggers, and Logic App email notifications for pipeline success/failure.

🔹 **Azure Data Lake Storage Gen2** — acts as the central storage layer for the raw and transformed data.

🔹 **Azure Databricks + Unity Catalog** — processes the data using PySpark through a Bronze → Silver → Gold Medallion Architecture.

🔹 **Data Quality Gate** — a custom validation layer implemented to check for null values, negative values, duplicates, and invalid categories before allowing data to move forward. If any check fails, the pipeline halts before writing to Silver.

🔹 **Azure Synapse Analytics** — uses Serverless SQL and `OPENROWSET` to query the prepared data.

🔹 **Power BI** — used for the reporting layer, with KPIs and visual analysis of sales performance across agents, products, sectors, and other business dimensions.

## Medallion Architecture

| Layer | Purpose |
|---|---|
| **Bronze** | Raw CRM data, untouched, as ingested |
| **Silver** | Cleaned, validated, deduplicated data — passed through the Data Quality Gate |
| **Gold** | Business-ready aggregated tables: revenue by sector, win rate by agent, monthly sales trend, top products by deals won, revenue by office location |

## Data Quality Gate

Rather than letting data flow silently from Bronze to Silver, this project includes a custom validation layer that runs a set of assert-based checks — null checks, negative-value checks, duplicate detection, and category/domain validation — before any data is written to Silver. If a check fails, the pipeline stops and reports exactly which check failed and why, instead of allowing bad data downstream.

## Dashboard

<img width="917" height="520" alt="Report" src="https://github.com/user-attachments/assets/b6a89cbf-fa45-4a8a-8ed9-cd28a294be01" />

The Power BI report includes KPI cards (Total Deals, Deals Won, Deals Lost), a monthly sales trend line chart, revenue breakdowns by sector and office location, top sales agents by deal value, and product performance by deal count and average deal size.


This project was a great step toward turning theoretical knowledge into practical, hands-on experience with the Azure Data Engineering stack.

## Repository Structure

```
Azure-CRM-Project/
├── Data Source/          # Raw CRM CSV files
├── datafactory/           # ADF pipeline definitions (Git-synced)
├── Databricks/            # PySpark notebooks (Bronze→Silver, Silver→Gold)
├── Synapse/                # SQL views (OPENROWSET) over Gold data
├── PowerBI/                # Power BI report
└── README.md
```
