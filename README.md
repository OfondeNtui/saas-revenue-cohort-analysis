# 📊 SaaS Revenue, Cohort & Churn Analysis

## 🔎 Project Overview
This project analyzes SaaS subscription performance to uncover key drivers of revenue growth, customer retention, and churn behavior.

Using SQL (BigQuery) and Tableau, I built an end-to-end BI solution to transform raw subscription data into actionable business insights.

---

## 🎯 Business Problem
The company lacked clear visibility into customer lifecycle and revenue performance, making it difficult to:

- Track Monthly Recurring Revenue (MRR)
- Understand churn patterns
- Evaluate cohort retention trends
- Identify revenue risks and growth opportunities

---

## 📊 Dashboard Highlights

### 📈 Revenue Performance Dashboard
- Monthly revenue trend with average benchmark
- Revenue by acquisition channel
- KPIs: Total Revenue, ARPU, Active Customers

### 🔥 Cohort Retention Analysis
- Monthly cohort heatmap showing retention drop-off
- Key insight: ~62.5% of users churn after Month 1

### 📉 Churn & Retention Dashboard
- Net Revenue Retention (NRR)
- Monthly churn rate trends
- Customer behavior insights

---

## 🗄️ Data Model

The project uses four core tables:

- `customers`
- `subscriptions`
- `payments`
- `product_usage`

Data was transformed in BigQuery using a layered approach:

1. Raw Layer  
2. Clean Layer  
3. Cohort Analysis Layer  
4. Revenue Metrics Layer  

---

## 📈 Key Metrics

- Monthly Recurring Revenue (MRR)
- Average Revenue Per User (ARPU)
- Churn Rate
- Customer Lifetime Value (LTV)
- Net Revenue Retention (NRR)
- Cohort Retention %

---

## 🧠 Key Insights

- Significant early churn: ~62.5% of users drop after Month 1  
- Revenue peaked before showing signs of decline → potential slowdown  
- Retained users drive the majority of revenue growth  
- High churn rate (~28%) highlights need for retention strategies  

---

## 🛠️ Tools Used

- Google BigQuery (SQL)
- Tableau (Data Visualization)
- GitHub (Version Control)

---

## 📸 Dashboard Preview

*(Add screenshots here — VERY IMPORTANT)*

---

## 📂 Repository Structure

📁 sql
   ├── 01_raw_tables.sql
   ├── 02_clean_layer.sql
   ├── 03_cohort_analysis.sql
   └── 04_revenue_metrics.sql

📁 dashboards
   ├── dashboard_1.png
   ├── dashboard_2.png
   └── dashboard_3.png

📄 README.md

---

## 🚀 Business Impact

This project provides:

- Improved visibility into customer retention and churn drivers  
- Data-driven insights for revenue optimization  
- Early detection of performance decline  
- Strategic input for product and growth teams  

---

👤 **Author:** Agbor O. Ntui  
📊 Business Intelligence Analyst  
