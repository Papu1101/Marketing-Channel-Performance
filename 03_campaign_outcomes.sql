-- ============================================================
--  CONNECT SPEND TO OUTCOMES
-- ============================================================

--Campaign Level signup outcomes::

SELECT
    channel_key,
    campaign_key,
    COUNT(*) AS total_signups,
    COUNT(*) FILTER (
        WHERE subscription_start_date IS NOT NULL
    ) AS paying_subscribers,
    SUM(revenue_first_90_days) AS revenue_first_90_days
FROM signups_final
WHERE campaign_key IS NOT NULL
GROUP BY
    channel_key,
    campaign_key
ORDER BY total_signups DESC;

---- Join campaign spend with outcomes ---------------------

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
        SUM(revenue_first_90_days) AS revenue_first_90_days
    FROM signups_final
    WHERE campaign_key IS NOT NULL
    GROUP BY
        channel_key,
        campaign_key
)
SELECT
    s.channel_key,
    s.campaign_key,
    s.total_spend,
    s.total_impressions,
    s.total_clicks,
    o.total_signups,
    o.paying_subscribers,
    o.revenue_first_90_days
FROM campaign_spend s
LEFT JOIN campaign_outcomes o
    ON s.channel_key = o.channel_key
    AND s.campaign_key = o.campaign_key
ORDER BY s.total_spend DESC;


---Validating the campaign join ------

WITH campaign_spend AS (
    SELECT
        channel_key,
        campaign_key,
        SUM(spend) AS total_spend
    FROM ad_spend_final
    GROUP BY
        channel_key,
        campaign_key
),
campaign_outcomes AS (
    SELECT
        channel_key,
        campaign_key,
        COUNT(*) AS total_signups
    FROM signups_final
    WHERE campaign_key IS NOT NULL
    GROUP BY
        channel_key,
        campaign_key
)
SELECT
    s.channel_key,
    s.campaign_key,
    s.total_spend,
    o.total_signups
FROM campaign_spend s
LEFT JOIN campaign_outcomes o
    ON s.channel_key = o.channel_key
    AND s.campaign_key = o.campaign_key
WHERE o.campaign_key IS NULL;

---Marketing Efficiency Metrics -----

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
        SUM(revenue_first_90_days) AS revenue_first_90_days
    FROM signups_final
    WHERE campaign_key IS NOT NULL
    GROUP BY
        channel_key,
        campaign_key
)
SELECT
    s.channel_key,
    s.campaign_key,
    s.total_spend,
    s.total_impressions,
    s.total_clicks,
    o.total_signups,
    o.paying_subscribers,
    o.revenue_first_90_days,
    -- Signup to paying conversion rate
    ROUND(
        (o.paying_subscribers::NUMERIC
        / NULLIF(o.total_signups, 0)) * 100,
        2
    ) AS signup_to_paid_rate,
    -- Cost per signup
    ROUND(
        s.total_spend
        / NULLIF(o.total_signups, 0),
        2
    ) AS cost_per_signup,
    -- Cost per paying subscriber
    ROUND(
        s.total_spend
        / NULLIF(o.paying_subscribers, 0),
        2
    ) AS cost_per_paying_subscriber,
    -- Return on Ad Spend
    ROUND(
        o.revenue_first_90_days
        / NULLIF(s.total_spend, 0),
        2
    ) AS roas
FROM campaign_spend s
LEFT JOIN campaign_outcomes o
    ON s.channel_key = o.channel_key
    AND s.campaign_key = o.campaign_key
ORDER BY roas DESC;

---Revenue ---

SELECT
    SUM(revenue_first_90_days) AS total_paid_campaign_revenue
FROM signups_final
WHERE campaign_key IS NOT NULL;


SELECT
    SUM(revenue_first_90_days) AS total_revenue
FROM signups_final;

SELECT
    COUNT(*) FILTER (
        WHERE subscription_start_date IS NOT NULL
        AND campaign_key IS NOT NULL
    ) AS paid_campaign_subscribers
FROM signups_final;
