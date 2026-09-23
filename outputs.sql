-- ============================================================
-- FINAL CAMPAIGN METRICS
-- Output: campaign_metrics.csv
-- ============================================================

WITH campaign_spend AS (
    SELECT
        channel_key,
        campaign_key,
        SUM(spend) AS total_spend,
        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks
    FROM ad_spend_final
    GROUP BY
        channel_key,
        campaign_key
),
campaign_outcomes AS (
    SELECT
        channel_key,
        campaign_key,
        COUNT(*) AS total_signups,
        COUNT(*) FILTER (
            WHERE subscription_start_date IS NOT NULL
        ) AS paying_subscribers,
        SUM(revenue_first_90_days)
            AS revenue_first_90_days
    FROM signups_final
    WHERE campaign_key IS NOT NULL
    GROUP BY
        channel_key,
        campaign_key
)
SELECT
    -- Campaign identification
    s.channel_key,
    s.campaign_key,
    -- Advertising performance
    ROUND(s.total_spend, 2)
        AS total_spend,
    s.total_impressions,
    s.total_clicks,
    ROUND(
        s.total_clicks::NUMERIC
        / NULLIF(s.total_impressions, 0) * 100,
        2
    ) AS ctr_percent,
    ROUND(
        s.total_spend
        / NULLIF(s.total_clicks, 0),
        2
    ) AS cpc,
    -- Customer outcomes
    o.total_signups,
    o.paying_subscribers,
    ROUND(
        o.paying_subscribers::NUMERIC
        / NULLIF(o.total_signups, 0) * 100,
        2
    ) AS signup_to_paid_rate,
    -- Acquisition costs
    ROUND(
        s.total_spend
        / NULLIF(o.total_signups, 0),
        2
    ) AS cost_per_signup,
    ROUND(
        s.total_spend
        / NULLIF(o.paying_subscribers, 0),
        2
    ) AS cost_per_paying_subscriber,
    -- Revenue
    ROUND(
        o.revenue_first_90_days,
        2
    ) AS revenue_first_90_days,
    -- Return on advertising spend
    ROUND(
        o.revenue_first_90_days
        / NULLIF(s.total_spend, 0),
        2
    ) AS roas
FROM campaign_spend s
LEFT JOIN campaign_outcomes o
    ON s.channel_key = o.channel_key
    AND s.campaign_key = o.campaign_key
ORDER BY
    s.channel_key,
    s.total_spend DESC;