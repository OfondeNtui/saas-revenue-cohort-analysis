# 📊 SaaS Revenue Cohort & Churn Analysis

## 🔎 Project Overview
This project analyzes SaaS subscription revenue performance using BigQuery.
The objective was to evaluate churn, cohort retention, and revenue growth patterns to support executive-level decision-making.

---

## 🎯 Business Problem
The company needed visibility into:

- Monthly Recurring Revenue (MRR)
- Customer churn rate
- Cohort retention performance
- Revenue concentration risk
- Expansion vs contraction revenue trends

---

## 🗄️ Data Model

The project uses four main tables:

- customers
- subscriptions
- payments
- product_usage

Data was transformed using SQL in BigQuery following a layered approach:

1. Raw layer
2. Clean layer
3. Cohort analysis layer
4. Revenue metrics layer

---

## 📈 Key Metrics Calculated

- Monthly Recurring Revenue (MRR)
- Average Revenue Per User (ARPU)
- Churn Rate
- Customer Lifetime Value (LTV)
- Revenue Growth Rate
- Cohort Retention %

---

## 🧠 Key Insights

- Early churn is highest within first 2 billing cycles
- Revenue growth is driven primarily by retained mid-tier subscribers
- Specific cohorts show declining engagement before churn
- High-value customers exhibit lower churn probability

---

## 🛠️ Tools Used

- Google BigQuery (SQL)
- Tableau (for visualization)
- GitHub (version control)

---

## 📂 Repository Structure

```
saas-revenue-cohort-analysis/
│
├── sql/
│   ├── 01_raw_tables.sql
│   ├── 02_clean_layer.sql
│   ├── 03_cohort_analysis.sql
│   └── 04_revenue_metrics.sql
│
└── README.md
```

---

## 🚀 Business Impact

This analysis enables:

- Revenue forecasting improvements
- Targeted retention strategies
- Early churn detection
- Executive KPI monitoring

---

📍 Author: Agbor O. Ntui  
📊 Data / Business Intelligence Analyst  HERE]

