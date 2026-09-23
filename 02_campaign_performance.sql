--  ============================================================
--     CAMPAIGN PERFORMANCE METRICS
-- ============================================================

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
ORDER BY total_spend DESC;

--  ============================================================
--    CTR and CPC
-- ============================================================

WITH campaign_metrics AS (
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
)
SELECT
    channel_key,
    campaign_key,
    total_spend,
    total_impressions,
    total_clicks,
    ROUND(
        (total_clicks::NUMERIC / NULLIF(total_impressions, 0)) * 100,
        2
    ) AS ctr_percent,
    ROUND(
        total_spend / NULLIF(total_clicks, 0),
        2
    ) AS cpc
FROM campaign_metrics
ORDER BY total_spend DESC;

SELECT
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks
FROM ad_spend_final;

SELECT
    SUM(total_spend) AS aggregated_spend
FROM (
    SELECT
        channel_key,
        campaign_key,
        SUM(spend) AS total_spend
    FROM ad_spend_final
    GROUP BY channel_key, campaign_key
) AS campaign_totals;