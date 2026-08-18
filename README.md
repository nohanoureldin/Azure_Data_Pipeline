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

## Data Source

Sales CRM dataset (Maven Analytics) — 5 tables:
- `accounts` — company name, sector, revenue, employee count, office location, parent company
- `products` — product name, series, sales price
- `sales_pipeline` — opportunity ID, sales agent, product, account, deal stage, engage/close dates, close value
- `sales_teams` — sales agent, manager, regional office
- `data_dictionary` — column definitions for the above

## Pipeline Components

### Azure Data Factory
Ingests the on-premises CSV files into the cloud.
- **Self-Hosted Integration Runtime** — a secure gateway installed on the local machine, allowing Data Factory to reach on-prem files without exposing them publicly
- **Git integration** (GitHub, `dev`/`main`/`adf_publish` branches) — pipeline definitions are version-controlled, with a `dev` branch for active work and an auto-managed `adf_publish` branch
- **Copy activities** — one per source table, landing files in the `raw-data` container in ADLS Gen2
- **Scheduled trigger** — runs the pipeline automatically at set intervals
- **Logic App integration** — sends email notifications with pipeline name, status, run ID, and timestamp on both success and failure
- **Azure Monitor** — tracks pipeline run metrics (successes, failures) for operational visibility

### Azure Data Lake Storage Gen2
Central storage layer, with hierarchical namespace enabled (true Data Lake Gen2 behavior, not flat blob storage). Holds the `raw-data` container that Data Factory writes to.

### Azure Databricks + Unity Catalog
Processes and transforms the data using PySpark, structured as a Medallion Architecture:

| Layer | Contents |
|---|---|
| **Bronze** | Raw CRM data loaded from ADLS, untouched |
| **Silver** | Cleaned data — renamed columns, nulls handled, validated by the Data Quality Gate |
| **Gold** | Aggregated business tables — revenue by sector, win rate by agent, monthly sales trend, top products by deals won, revenue by office location |

Data is stored in **Unity Catalog Volumes** rather than legacy DBFS mounts — Unity Catalog blocks the older `dbutils.fs.mount()` pattern by design, so this project uses managed Volumes (`/Volumes/catalog/schema/volume_name/`) as the modern, governed alternative.

### Data Quality Gate (custom addition)
A validation layer built specifically for this project, sitting between Bronze and Silver. Before any data is written to Silver, it must pass a set of assert-based checks per table:
- No unexpected null values in key columns
- No negative values in numeric fields that should never be negative (revenue, employee count, close value)
- No fully duplicate rows
- Categorical fields (e.g. `deal_stage`) only contain expected values

If any check fails, the pipeline raises an error and halts before writing to Silver — bad data never silently propagates downstream. During development, this gate actually caught a real issue: the data contains a 4th `deal_stage` value (`Prospecting`) not mentioned in the original data documentation, which the gate flagged for a manual review and fix.

### Azure Synapse Analytics
Serverless SQL pool used to query the Gold layer directly from storage using `OPENROWSET`, without needing to load data into a dedicated database. SQL views are created per Gold table (e.g. `v_revenue_by_sector`, `v_win_rate_by_agent`), enabling standard SQL querying and ad-hoc analysis on top of the pipeline's output.

### Power BI
The reporting layer, connected directly to the Silver and Gold data in ADLS Gen2. The dashboard includes:
- **KPI cards** — Total Deals, Deals Won, Deals Lost
- **Monthly Sales Trend** — line chart of total closed-deal value over time
- **Top 5 Sales Agents by Deal Value** — stacked bar chart, split by deal stage
- **Revenue by Sector** — donut chart
- **Revenue by Office Location** — bar chart (used in place of a map visual, which required tenant admin rights not available on a personal trial subscription)
- **Deal Count by Product** and **Average Deal Size by Product** — bar charts showing both sales volume and deal value by product

## Medallion Architecture

| Layer | Purpose |
|---|---|
| **Bronze** | Raw CRM data, untouched, as ingested |
| **Silver** | Cleaned, validated, deduplicated data — passed through the Data Quality Gate |
| **Gold** | Business-ready aggregated tables: revenue by sector, win rate by agent, monthly sales trend, top products by deals won, revenue by office location |

## Data Quality Gate

Rather than letting data flow silently from Bronze to Silver, this project includes a custom validation layer that runs a set of assert-based checks — null checks, negative-value checks, duplicate detection, and category/domain validation — before any data is written to Silver. If a check fails, the pipeline stops and reports exactly which check failed and why, instead of allowing bad data downstream.

### Supporting Services
- **Azure Logic Apps** — HTTP-triggered workflow that sends pipeline status emails
- **Azure Monitor** — metrics dashboard for pipeline health
- **Azure Key Vault** — stores the storage account access key securely; Databricks retrieves it via a Databricks Secret Scope linked to Key Vault, so credentials are never hardcoded in notebooks

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
