-- ============================================================
-- File: 01_raw_tables.sql
-- Project: SaaS Revenue & Cohort Analysis
-- Layer: Raw
-- Description:
-- Generates simulated messy SaaS dataset.
-- ============================================================


-- ------------------------------------------------------------
-- Create Customers Table
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_raw.customers` AS
WITH base AS (
  SELECT
    GENERATE_UUID() AS customer_id,
    DATE_SUB(CURRENT_DATE(), INTERVAL CAST(ROUND(RAND()*720) AS INT64) DAY) AS signup_date,
    CASE
      WHEN RAND() < 0.25 THEN 'Google Ads'
      WHEN RAND() < 0.50 THEN 'LinkedIn'
      WHEN RAND() < 0.75 THEN 'Organic'
      ELSE 'Referral'
    END AS acquisition_channel,
    CASE
      WHEN RAND() < 0.3 THEN 'Germany'
      WHEN RAND() < 0.5 THEN 'France'
      WHEN RAND() < 0.7 THEN 'UK'
      ELSE 'Netherlands'
    END AS country,
    CASE
      WHEN RAND() < 0.4 THEN 'Small'
      WHEN RAND() < 0.75 THEN 'Medium'
      ELSE 'Enterprise'
    END AS company_size,
    CASE
      WHEN RAND() < 0.6 THEN 'Basic'
      WHEN RAND() < 0.9 THEN 'Pro'
      ELSE 'Enterprise'
    END AS plan_type
  FROM UNNEST(GENERATE_ARRAY(1, 2000))
)
SELECT * FROM base;


-- ------------------------------------------------------------
-- Create Subscriptions Table
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_raw.subscriptions` AS
WITH subs AS (
  SELECT
    GENERATE_UUID() AS subscription_id,
    c.customer_id,
    c.signup_date AS start_date,
    CASE
      WHEN RAND() < 0.35 THEN DATE_ADD(c.signup_date, INTERVAL CAST(ROUND(RAND()*300) AS INT64) DAY)
      ELSE NULL
    END AS end_date,
    CASE
      WHEN c.plan_type = 'Basic' THEN 29
      WHEN c.plan_type = 'Pro' THEN 79
      ELSE 199
    END AS monthly_price,
    CASE
      WHEN RAND() < 0.8 THEN 'Monthly'
      ELSE 'Yearly'
    END AS billing_cycle,
    CASE
      WHEN RAND() < 0.2 THEN ROUND(RAND()*20,2)
      ELSE 0
    END AS discount_applied
  FROM `saas-revenue-cohort-analysis.saas_raw.customers` c
)
SELECT * FROM subs;


-- ------------------------------------------------------------
-- Create Payments Table
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_raw.payments` AS
WITH base_payments AS (
  SELECT
    GENERATE_UUID() AS payment_id,
    s.customer_id,
    DATE_ADD(s.start_date, INTERVAL CAST(ROUND(RAND()*400) AS INT64) DAY) AS payment_date,
    CASE
      WHEN s.billing_cycle = 'Monthly' THEN s.monthly_price - s.discount_applied
      ELSE (s.monthly_price * 12) - s.discount_applied
    END AS amount,
    CASE
      WHEN RAND() < 0.85 THEN 'paid'
      WHEN RAND() < 0.95 THEN 'failed'
      ELSE 'refunded'
    END AS status
  FROM `saas-revenue-cohort-analysis.saas_raw.subscriptions` s,
  UNNEST(GENERATE_ARRAY(1, 5)) AS payment_cycle
)
SELECT * FROM base_payments;


-- ------------------------------------------------------------
-- Create Product Usage Table
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE `saas-revenue-cohort-analysis.saas_raw.product_usage` AS
WITH usage_data AS (
  SELECT
    c.customer_id,
    DATE_ADD(c.signup_date, INTERVAL CAST(ROUND(RAND()*365) AS INT64) DAY) AS usage_date,
    CASE
      WHEN RAND() < 0.25 THEN 'Dashboard'
      WHEN RAND() < 0.50 THEN 'Reports'
      WHEN RAND() < 0.75 THEN 'Integrations'
      ELSE 'Automation'
    END AS feature_used,
    CAST(ROUND(RAND()*20) AS INT64) AS session_count
  FROM `saas-revenue-cohort-analysis.saas_raw.customers` c,
  UNNEST(GENERATE_ARRAY(1, 10)) AS usage_cycle
)
SELECT * FROM usage_data;