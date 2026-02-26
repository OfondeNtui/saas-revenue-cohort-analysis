🚀 SaaS Revenue & Cohort Analytics | BigQuery + Tableau
📌 Project Overview

This project simulates a SaaS company experiencing revenue volatility and churn.

The objective was to design a structured BI data model in Google BigQuery, calculate executive SaaS KPIs, and prepare the data for strategic dashboard reporting.

The architecture follows a layered approach:

Raw Layer

Clean / Transformation Layer

Analytics Layer (KPI & revenue modeling)

🎯 Business Problem

The company required visibility into:

Monthly Recurring Revenue (MRR)

Customer Churn

Cohort Retention

Customer Lifetime Value (LTV)

Net Revenue Retention (NRR)

Expansion vs Contraction Revenue

The goal was to identify whether revenue growth was driven by new customers or expansion of existing accounts.

🏗 Data Architecture

Raw Tables

customers

subscriptions

payments

product_usage

Clean Layer

Standardized dates

Revenue normalization

Subscription status logic

Derived revenue_recognized field

Analytics Layer

Cohort retention table

Monthly churn table

Revenue metrics table

Revenue movement (expansion, contraction, churned revenue)

📊 Key Metrics Calculated

Monthly Recurring Revenue (MRR)

ARPU

LTV

Gross Churn Rate

Net Revenue Retention (NRR)

Revenue Expansion & Contraction

All calculations were built using advanced SQL techniques:

Window functions (LAG)

Cohort grouping

Time-series aggregation

Revenue decomposition

🛠 Tech Stack

Google BigQuery

SQL (Window Functions, CTEs, Aggregations)

Tableau (for executive dashboard)

📈 Executive Insight Example

Revenue volatility was largely driven by contraction within mid-tier subscription plans rather than pure customer churn — indicating pricing sensitivity rather than acquisition failure.

🔗 Dashboard

Tableau Public Link:
[PASTE YOUR LINK HERE]

