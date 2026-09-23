CREATE TABLE ad_spend (
    date DATE,
    channel VARCHAR(100),
    campaign VARCHAR(200),
    impressions INTEGER,
    clicks INTEGER,
    spend NUMERIC(12,2)
);

SELECT * FROM ad_spend;

-- 1. Total rows
SELECT COUNT(*) AS total_rows
FROM ad_spend;

-- 2.Date range

SELECT
    MIN(date) AS start_date,
    MAX(date) AS end_date
FROM ad_spend;

-- Check NULL values
SELECT
    COUNT(*) FILTER (WHERE date IS NULL) AS null_date,
    COUNT(*) FILTER (WHERE channel IS NULL) AS null_channel,
    COUNT(*) FILTER (WHERE campaign IS NULL) AS null_campaign,
    COUNT(*) FILTER (WHERE impressions IS NULL) AS null_impressions,
    COUNT(*) FILTER (WHERE clicks IS NULL) AS null_clicks,
    COUNT(*) FILTER (WHERE spend IS NULL) AS null_spend
FROM ad_spend;
--Duplicates
SELECT
    date,
    channel,
    campaign,
    COUNT(*) AS duplicate_count
FROM ad_spend
GROUP BY date, channel, campaign
HAVING COUNT(*) > 1;

------------

SELECT
    date,
    channel,
    campaign,
    COUNT(*) AS duplicate_count,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks
FROM ad_spend
GROUP BY date, channel, campaign
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, date;

-------

SELECT
    date,
    channel,
    campaign,
    impressions,
    clicks,
    spend,
    COUNT(*) AS row_count
FROM ad_spend
GROUP BY
    date,
    channel,
    campaign,
    impressions,
    clicks,
    spend
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

SELECT COUNT(*) AS original_rows
FROM ad_spend;

SELECT COUNT(*) AS unique_rows
FROM (
    SELECT DISTINCT
        date,
        channel,
        campaign,
        impressions,
        clicks,
        spend
    FROM ad_spend
) AS cleaned;


CREATE TABLE ad_spend_clean AS
SELECT DISTINCT
    date,
    channel,
    campaign,
    impressions,
    clicks,
    spend
FROM ad_spend;

SELECT COUNT(*) AS clean_rows
FROM ad_spend_clean;


SELECT
    COUNT(*) FILTER (WHERE date IS NULL) AS null_date,
    COUNT(*) FILTER (WHERE channel IS NULL) AS null_channel,
    COUNT(*) FILTER (WHERE campaign IS NULL) AS null_campaign,
    COUNT(*) FILTER (WHERE impressions IS NULL) AS null_impressions,
    COUNT(*) FILTER (WHERE clicks IS NULL) AS null_clicks,
    COUNT(*) FILTER (WHERE spend IS NULL) AS null_spend,
    COUNT(*) FILTER (WHERE impressions < 0) AS negative_impressions,
    COUNT(*) FILTER (WHERE clicks < 0) AS negative_clicks,
    COUNT(*) FILTER (WHERE spend < 0) AS negative_spend
FROM ad_spend_clean;

SELECT COUNT(*) AS invalid_click_rows
FROM ad_spend_clean
WHERE clicks > impressions;


----------------------------------------------


CREATE TABLE signups (
    user_id INTEGER,
    signup_date DATE,
    channel VARCHAR(100),
    campaign VARCHAR(200),
    subscription_start_date DATE,
    plan VARCHAR(50),
    revenue_first_90_days NUMERIC(12,2)
);

SELECT * FROM signups;

SELECT COUNT(*) AS total_rows
FROM signups;

SELECT
    COUNT(*) FILTER (WHERE user_id IS NULL) AS null_user_id,
    COUNT(*) FILTER (WHERE signup_date IS NULL) AS null_signup_date,
    COUNT(*) FILTER (WHERE channel IS NULL) AS null_channel,
    COUNT(*) FILTER (WHERE campaign IS NULL) AS null_campaign,
    COUNT(*) FILTER (WHERE subscription_start_date IS NULL) AS null_subscription_date,
    COUNT(*) FILTER (WHERE plan IS NULL) AS null_plan,
    COUNT(*) FILTER (WHERE revenue_first_90_days IS NULL) AS null_revenue
FROM signups;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE user_id IS NULL) AS missing_user_id,
    COUNT(*) FILTER (WHERE signup_date IS NULL) AS missing_signup_date,
    COUNT(*) FILTER (WHERE channel IS NULL) AS missing_channel,
    COUNT(*) FILTER (WHERE campaign IS NULL) AS missing_campaign,
    COUNT(*) FILTER (WHERE subscription_start_date IS NULL) AS missing_subscription_date,
    COUNT(*) FILTER (WHERE plan IS NULL) AS missing_plan,
    COUNT(*) FILTER (WHERE revenue_first_90_days IS NULL) AS missing_revenue
FROM signups;


SELECT
    channel,
    COUNT(*) AS total_signups,
    COUNT(*) FILTER (WHERE campaign IS NULL) AS missing_campaign
FROM signups
GROUP BY channel
ORDER BY channel;

SELECT
    COUNT(*) AS total_users,
    COUNT(*) FILTER (
        WHERE subscription_start_date IS NULL
    ) AS never_subscribed,
    COUNT(*) FILTER (
        WHERE subscription_start_date IS NOT NULL
    ) AS paying_users
FROM signups;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT user_id) AS unique_users
FROM signups;


SELECT
    channel,
    campaign,
    COUNT(*) AS signups
FROM signups
GROUP BY channel, campaign
ORDER BY channel, signups DESC;


SELECT
    channel,
    campaign,
    COUNT(*) AS signup_count
FROM signups
GROUP BY channel, campaign
ORDER BY channel, signup_count DESC;



----


CREATE TABLE ad_spend_final AS
SELECT
    date,
    channel,
    campaign,
    impressions,
    clicks,
    spend,
    LOWER(TRIM(REPLACE(channel, ' ', '_'))) AS channel_key,
    LOWER(TRIM(REPLACE(campaign, ' ', '_'))) AS campaign_key
FROM ad_spend_clean;


CREATE TABLE signups_final AS
SELECT
    user_id,
    signup_date,
    channel,
    campaign,
    subscription_start_date,
    plan,
    revenue_first_90_days,
    LOWER(TRIM(REPLACE(channel, ' ', '_'))) AS channel_key,
    CASE
        WHEN campaign IS NOT NULL
        THEN LOWER(TRIM(REPLACE(campaign, ' ', '_')))
        ELSE NULL
    END AS campaign_key
FROM signups;

SELECT DISTINCT
    channel,
    channel_key
FROM ad_spend_final
ORDER BY channel;

SELECT DISTINCT
    channel,
    channel_key
FROM signups_final
ORDER BY channel;

SELECT DISTINCT
    channel_key,
    campaign,
    campaign_key
FROM ad_spend_final
ORDER BY channel_key, campaign_key;

SELECT DISTINCT
    channel_key,
    campaign,
    campaign_key
FROM signups_final
ORDER BY channel_key, campaign_key;


SELECT DISTINCT channel_key
FROM ad_spend_final
EXCEPT
SELECT DISTINCT channel_key
FROM signups_final;

SELECT DISTINCT channel_key
FROM signups_final
EXCEPT
SELECT DISTINCT channel_key
FROM ad_spend_final;

SELECT DISTINCT
    channel_key,
    campaign_key
FROM ad_spend_final
EXCEPT
SELECT DISTINCT
    channel_key,
    campaign_key
FROM signups_final;

SELECT DISTINCT
    channel_key,
    campaign_key
FROM signups_final
WHERE campaign_key IS NOT NULL
EXCEPT
SELECT DISTINCT
    channel_key,
    campaign_key
FROM ad_spend_final;
