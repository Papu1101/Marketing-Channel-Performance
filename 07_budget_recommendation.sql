-- ============================================================
-- NEXT SIX-MONTH BUDGET RECOMMENDATION
-- ============================================================

---- Each channel's share of current spend ----

WITH channel_spend AS (
    SELECT
        channel_key,
        SUM(spend) AS total_spend
    FROM ad_spend_final
    GROUP BY channel_key
)
SELECT
    channel_key,
    ROUND(total_spend, 2) AS total_spend,
    ROUND(
        total_spend
        / SUM(total_spend) OVER () * 100,
        2
    ) AS current_budget_share
FROM channel_spend
ORDER BY total_spend DESC;

----ROAS-based budget weights-----

WITH channel_spend AS (
    SELECT
        channel_key,
        SUM(spend) AS total_spend
    FROM ad_spend_final
    GROUP BY channel_key
),
channel_revenue AS (
    SELECT
        channel_key,
        SUM(revenue_first_90_days) AS revenue_first_90_days
    FROM signups_final
    WHERE campaign_key IS NOT NULL
    GROUP BY channel_key
),
channel_roas AS (
    SELECT
        s.channel_key,
        s.total_spend,
        r.revenue_first_90_days,
        r.revenue_first_90_days
        / NULLIF(s.total_spend, 0) AS roas
    FROM channel_spend s
    JOIN channel_revenue r
        ON s.channel_key = r.channel_key
)
SELECT
    channel_key,
    ROUND(total_spend, 2) AS total_spend,
    ROUND(revenue_first_90_days, 2)
        AS revenue_first_90_days,
    ROUND(roas, 2) AS roas,
    ROUND(
        roas / SUM(roas) OVER () * 100,
        2
    ) AS roas_weight_percent
FROM channel_roas
ORDER BY roas DESC;

----Recommended budget split----

WITH channel_spend AS (
    SELECT
        channel_key,
        SUM(spend) AS total_spend
    FROM ad_spend_final
    GROUP BY channel_key
),
channel_revenue AS (
    SELECT
        channel_key,
        SUM(revenue_first_90_days) AS revenue_first_90_days
    FROM signups_final
    WHERE campaign_key IS NOT NULL
    GROUP BY channel_key
),
channel_roas AS (
    SELECT
        s.channel_key,
        s.total_spend,
        r.revenue_first_90_days,
        r.revenue_first_90_days
        / NULLIF(s.total_spend, 0) AS roas
    FROM channel_spend s
    JOIN channel_revenue r
        ON s.channel_key = r.channel_key
),
budget_allocation AS (
    SELECT
        channel_key,
        total_spend,
        revenue_first_90_days,
        roas,
        -- ROAS-based allocation
        roas / SUM(roas) OVER () AS roas_weight
    FROM channel_roas
)
SELECT
    channel_key,
    ROUND(total_spend, 2) AS historical_spend,
    ROUND(revenue_first_90_days, 2)
        AS first_90_day_revenue,
    ROUND(roas, 2) AS roas,
    ROUND(roas_weight * 100, 2)
        AS recommended_budget_percent
FROM budget_allocation
ORDER BY recommended_budget_percent DESC;

--Final recommended allocation----

WITH channel_spend AS (
    SELECT
        channel_key,
        SUM(spend) AS total_spend
    FROM ad_spend_final
    GROUP BY channel_key
),
channel_revenue AS (
    SELECT
        channel_key,
        SUM(revenue_first_90_days) AS revenue_first_90_days
    FROM signups_final
    WHERE campaign_key IS NOT NULL
    GROUP BY channel_key
),
channel_metrics AS (
    SELECT
        s.channel_key,
        s.total_spend,
        r.revenue_first_90_days,
        r.revenue_first_90_days
        / NULLIF(s.total_spend, 0) AS roas
    FROM channel_spend s
    JOIN channel_revenue r
        ON s.channel_key = r.channel_key
),
weights AS (
    SELECT
        channel_key,
        total_spend,
        revenue_first_90_days,
        roas,
        total_spend
        / SUM(total_spend) OVER () AS historical_weight,
        roas
        / SUM(roas) OVER () AS roas_weight
    FROM channel_metrics
)
SELECT
    channel_key,
    ROUND(total_spend, 2) AS historical_spend,
    ROUND(revenue_first_90_days, 2)
        AS first_90_day_revenue,
    ROUND(roas, 2) AS roas,
    ROUND(historical_weight * 100, 2)
        AS historical_budget_percent,
    ROUND(roas_weight * 100, 2)
        AS roas_budget_percent,
    ROUND(
        (
            0.70 * roas_weight
            +
            0.30 * historical_weight
        ) * 100,
        2
    ) AS recommended_budget_percent
FROM weights
ORDER BY recommended_budget_percent DESC;