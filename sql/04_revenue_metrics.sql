-- ============================================================
-- File: 04_revenue_metrics.sql
-- Project: SaaS Revenue & Cohort Analysis
-- Layer: Analytics
-- Description:
-- Calculates executive-level SaaS revenue KPIs:
-- - Monthly Recurring Revenue (MRR)
-- - ARPU
-- - Churn Rate
-- - Customer Lifetime
-- - Lifetime Value (LTV)
-- - Revenue by Acquisition Channel
-- ============================================================


-- ------------------------------------------------------------
-- 1️⃣ Monthly Recurring Revenue (MRR)
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_analytics.mrr_monthly` AS
SELECT
  DATE_TRUNC(payment_date, MONTH) AS revenue_month,
  SUM(revenue_recognized) AS total_revenue
FROM `saas-revenue-cohort-analysis.saas_clean.payments_clean`
GROUP BY revenue_month
ORDER BY revenue_month;



-- ------------------------------------------------------------
-- 2️⃣ ARPU (Average Revenue Per User)
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_analytics.arpu` AS
SELECT
  m.revenue_month,
  m.total_revenue,
  COUNT(DISTINCT s.customer_id) AS active_customers,
  ROUND(m.total_revenue / COUNT(DISTINCT s.customer_id), 2) AS arpu
FROM `saas-revenue-cohort-analysis.saas_analytics.mrr_monthly` m
JOIN `saas-revenue-cohort-analysis.saas_clean.subscriptions_clean` s
  ON s.is_active = 1
GROUP BY m.revenue_month, m.total_revenue
ORDER BY m.revenue_month;



-- ------------------------------------------------------------
-- 3️⃣ Churn Rate (Overall)
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_analytics.churn_rate` AS
SELECT
  COUNTIF(churned = 1) AS churned_customers,
  -- ------------------------------------------------------------
-- 7️⃣ Monthly Churn Rate
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_analytics.monthly_churn_rate` AS

WITH churn_events AS (
  SELECT
    DATE_TRUNC(end_date, MONTH) AS churn_month,
    COUNT(DISTINCT customer_id) AS churned_customers
  FROM `saas-revenue-cohort-analysis.saas_clean.subscriptions_clean`
  WHERE end_date IS NOT NULL
  GROUP BY churn_month
),

active_base AS (
  SELECT
    DATE_TRUNC(start_date, MONTH) AS active_month,
    COUNT(DISTINCT customer_id) AS active_customers
  FROM `saas-revenue-cohort-analysis.saas_clean.subscriptions_clean`
  GROUP BY active_month
)

SELECT
  c.churn_month,
  c.churned_customers,
  a.active_customers,
  ROUND(c.churned_customers / a.active_customers * 100, 2) AS churn_rate_percentage
FROM churn_events c
LEFT JOIN active_base a
  ON c.churn_month = a.active_month
ORDER BY c.churn_month;
-- ------------------------------------------------------------
-- 8️⃣ Net Revenue Retention (NRR)
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_analytics.net_revenue_retention` AS

WITH monthly_revenue AS (
  SELECT
    DATE_TRUNC(payment_date, MONTH) AS revenue_month,
    customer_id,
    SUM(revenue_recognized) AS customer_revenue
  FROM `saas-revenue-cohort-analysis.saas_clean.payments_clean`
  GROUP BY revenue_month, customer_id
),

base_revenue AS (
  SELECT
    revenue_month,
    SUM(customer_revenue) AS total_revenue
  FROM monthly_revenue
  GROUP BY revenue_month
),

lag_revenue AS (
  SELECT
    revenue_month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY revenue_month) AS previous_month_revenue
  FROM base_revenue
)

SELECT
  revenue_month,
  total_revenue,
  previous_month_revenue,
  ROUND(total_revenue / previous_month_revenue * 100, 2) AS nrr_percentage
FROM lag_revenue
WHERE previous_month_revenue IS NOT NULL
ORDER BY revenue_month;-- ------------------------------------------------------------
-- 9️⃣ Revenue Expansion vs Contraction
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_analytics.revenue_movement` AS

WITH monthly_customer_revenue AS (
  SELECT
    DATE_TRUNC(payment_date, MONTH) AS revenue_month,
    customer_id,
    SUM(revenue_recognized) AS revenue
  FROM `saas-revenue-cohort-analysis.saas_clean.payments_clean`
  GROUP BY revenue_month, customer_id
),

revenue_with_lag AS (
  SELECT
    revenue_month,
    customer_id,
    revenue,
    LAG(revenue) OVER (
      PARTITION BY customer_id
      ORDER BY revenue_month
    ) AS previous_month_revenue
  FROM monthly_customer_revenue
)

SELECT
  revenue_month,
  SUM(CASE 
        WHEN revenue > previous_month_revenue THEN revenue - previous_month_revenue
        ELSE 0 
      END) AS expansion_revenue,

  SUM(CASE 
        WHEN revenue < previous_month_revenue THEN previous_month_revenue - revenue
        ELSE 0 
      END) AS contraction_revenue,

  SUM(CASE 
        WHEN revenue IS NULL AND previous_month_revenue IS NOT NULL THEN previous_month_revenue
        ELSE 0 
      END) AS churned_revenue

FROM revenue_with_lag
GROUP BY revenue_month
ORDER BY revenue_month;
  COUNT(*) AS total_customers,
  ROUND(COUNTIF(churned = 1) / COUNT(*) * 100, 2) AS churn_rate_percentage
FROM `saas-revenue-cohort-analysis.saas_clean.subscriptions_clean`;



-- ------------------------------------------------------------
-- 4️⃣ Customer Lifetime (Months)
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_analytics.customer_lifetime` AS
SELECT
  customer_id,
  DATE_DIFF(
    COALESCE(end_date, CURRENT_DATE()),
    start_date,
    MONTH
  ) AS lifetime_months
FROM `saas-revenue-cohort-analysis.saas_clean.subscriptions_clean`;



-- ------------------------------------------------------------
-- 5️⃣ Lifetime Value (LTV)
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_analytics.ltv` AS
SELECT
  s.customer_id,
  cl.lifetime_months,
  s.normalized_monthly_revenue,
  ROUND(cl.lifetime_months * s.normalized_monthly_revenue, 2) AS estimated_ltv
FROM `saas-revenue-cohort-analysis.saas_clean.subscriptions_clean` s
JOIN `saas-revenue-cohort-analysis.saas_analytics.customer_lifetime` cl
  ON s.customer_id = cl.customer_id;



-- ------------------------------------------------------------
-- 6️⃣ Revenue by Acquisition Channel
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_analytics.revenue_by_channel` AS
SELECT
  c.acquisition_channel,
  SUM(p.revenue_recognized) AS total_revenue
FROM `saas-revenue-cohort-analysis.saas_clean.payments_clean` p
JOIN `saas-revenue-cohort-analysis.saas_raw.customers` c
  ON p.customer_id = c.customer_id
GROUP BY c.acquisition_channel
ORDER BY total_revenue DESC;