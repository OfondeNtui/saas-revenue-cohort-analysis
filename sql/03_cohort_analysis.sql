-- ============================================================
-- File: 03_cohort_analysis.sql
-- Project: SaaS Revenue & Cohort Analysis
-- Layer: Analytics
-- Description:
-- Calculates cohort retention metrics including:
-- - Cohort size
-- - Monthly retention
-- - Retention percentage
-- ============================================================


-- ------------------------------------------------------------
-- Cohort Retention Calculation
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_analytics.cohort_retention` AS

WITH cohort_size AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT customer_id) AS total_customers
  FROM `saas-revenue-cohort-analysis.saas_clean.customer_cohorts`
  GROUP BY cohort_month
),

retention_calc AS (
  SELECT
    cohort_month,
    months_active,
    COUNT(DISTINCT customer_id) AS retained_customers
  FROM `saas-revenue-cohort-analysis.saas_clean.cohort_retention_base`
  GROUP BY cohort_month, months_active
)

SELECT
  r.cohort_month,
  r.months_active,
  r.retained_customers,
  cs.total_customers,
  ROUND(r.retained_customers / cs.total_customers * 100, 2) AS retention_rate
FROM retention_calc r
JOIN cohort_size cs
  ON r.cohort_month = cs.cohort_month
ORDER BY r.cohort_month, r.months_active;