-- ============================================================
-- SIX-MONTH PERFORMANCE TRENDS
-- ============================================================

--Performance Trend 

SELECT
    DATE_TRUNC('month', date)::DATE AS month,
    channel_key,
    campaign_key,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    ROUND(
        SUM(clicks)::NUMERIC
        / NULLIF(SUM(impressions), 0) * 100,
        2
    ) AS ctr_percent,
    ROUND(
        SUM(spend)
        / NULLIF(SUM(clicks), 0),
        2
    ) AS cpc
FROM ad_spend_final
GROUP BY
    DATE_TRUNC('month', date),
    channel_key,
    campaign_key
ORDER BY
    month,
    channel_key,
    campaign_key;


--campaigns that stopped running--

WITH campaign_months AS (
    SELECT
        channel_key,
        campaign_key,
        MIN(DATE_TRUNC('month', date)) AS first_month,
        MAX(DATE_TRUNC('month', date)) AS last_month,
        COUNT(DISTINCT DATE_TRUNC('month', date)) AS active_months
    FROM ad_spend_final
    GROUP BY
        channel_key,
        campaign_key
)
SELECT
    channel_key,
    campaign_key,
    first_month::DATE AS first_month,
    last_month::DATE AS last_month,
    active_months
FROM campaign_months
WHERE last_month < DATE '2025-06-01'
ORDER BY last_month;


---Campaigns active in each month---

SELECT
    DATE_TRUNC('month', date)::DATE AS month,
    COUNT(DISTINCT campaign_key) AS active_campaigns,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks
FROM ad_spend_final
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;

--Overall paid performance changed month by month-----


SELECT
    DATE_TRUNC('month', date)::DATE AS month,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    ROUND(
        SUM(clicks)::NUMERIC
        / NULLIF(SUM(impressions), 0) * 100,
        2
    ) AS ctr_percent,
    ROUND(
        SUM(spend)
        / NULLIF(SUM(clicks), 0),
        2
    ) AS cpc
FROM ad_spend_final
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;

---Monthly signup & revenue performance---

SELECT
    DATE_TRUNC('month', signup_date)::DATE AS month,
    COUNT(*) AS total_signups,
    COUNT(*) FILTER (
        WHERE subscription_start_date IS NOT NULL
    ) AS paying_subscribers,
    SUM(revenue_first_90_days) AS revenue_first_90_days,
    ROUND(
        COUNT(*) FILTER (
            WHERE subscription_start_date IS NOT NULL
        )::NUMERIC
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS signup_to_paid_rate
FROM signups_final
GROUP BY DATE_TRUNC('month', signup_date)
ORDER BY month;