-- ============================================================
--  PAID VS UNPAID SIGNUP PERFORMANCE
-- ============================================================

----Conversion Rate of Each Group ---

SELECT
    CASE
        WHEN channel_key IN (
            'paid_search',
            'paid_social',
            'display',
            'affiliate'
        )
        THEN 'paid'
        WHEN channel_key = 'organic'
        THEN 'organic'
        WHEN channel_key = 'referral'
        THEN 'referral'
    END AS acquisition_type,
    COUNT(*) AS total_signups,
    COUNT(*) FILTER (
        WHERE subscription_start_date IS NOT NULL
    ) AS paying_subscribers,
    ROUND(
        COUNT(*) FILTER (
            WHERE subscription_start_date IS NOT NULL
        )::NUMERIC
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS signup_to_paid_rate
FROM signups_final
GROUP BY acquisition_type
ORDER BY signup_to_paid_rate DESC;


---

SELECT
    COUNT(*) AS total_signups,
    COUNT(*) FILTER (
        WHERE subscription_start_date IS NOT NULL
    ) AS total_paying_subscribers
FROM signups_final;