-- ============================================================
-- File: 02_clean_layer.sql
-- Project: SaaS Revenue & Cohort Analysis
-- Layer: Clean
-- Description:
-- Applies business logic and prepares analytics-ready tables.
-- - Revenue normalization
-- - Churn definition
-- - Active flag definition
-- - Cohort preparation
-- ============================================================


-- ------------------------------------------------------------
-- Clean Subscriptions Table
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_clean.subscriptions_clean` AS
SELECT
  subscription_id,
  customer_id,
  start_date,
  end_date,
  monthly_price,
  billing_cycle,
  discount_applied,
  
  -- Normalize monthly revenue
  CASE
    WHEN billing_cycle = 'Yearly'
      THEN (monthly_price * 12 - discount_applied) / 12
    ELSE monthly_price - discount_applied
  END AS normalized_monthly_revenue,
  
  -- Churn flag
  CASE
    WHEN end_date IS NOT NULL THEN 1
    ELSE 0
  END AS churned,
  
  -- Active flag
  CASE
    WHEN end_date IS NULL THEN 1
    ELSE 0
  END AS is_active

FROM `saas-revenue-cohort-analysis.saas_raw.subscriptions`
WHERE start_date IS NOT NULL;



-- ------------------------------------------------------------
-- Clean Payments Table (Revenue Recognition Logic)
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_clean.payments_clean` AS
SELECT
  payment_id,
  customer_id,
  payment_date,
  amount,
  status,
  
  -- Only recognize successful payments as revenue
  CASE
    WHEN status = 'paid' THEN amount
    ELSE 0
  END AS revenue_recognized

FROM `saas-revenue-cohort-analysis.saas_raw.payments`;



-- ------------------------------------------------------------
-- Create Customer Cohorts
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_clean.customer_cohorts` AS
SELECT
  customer_id,
  DATE_TRUNC(signup_date, MONTH) AS cohort_month
FROM `saas-revenue-cohort-analysis.saas_raw.customers`;



-- ------------------------------------------------------------
-- Cohort Retention Base Table
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_clean.cohort_retention_base` AS
SELECT
  s.customer_id,
  cc.cohort_month,
  DATE_DIFF(
    COALESCE(s.end_date, CURRENT_DATE()),
    s.start_date,
    MONTH
  ) AS months_active
FROM `saas-revenue-cohort-analysis.saas_clean.subscriptions_clean` s
JOIN `saas-revenue-cohort-analysis.saas_clean.customer_cohorts` cc
  ON s.customer_id = cc.customer_id;