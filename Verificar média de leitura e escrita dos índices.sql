SELECT
    CAST(SUM(user_seeks + user_scans + user_lookups) AS decimal) / CAST(SUM(user_updates) + SUM(user_seeks + user_scans + user_lookups) AS decimal) * 100 AS ReadPercent ,
    CAST(SUM(user_updates) AS decimal) / CAST(SUM(user_updates) + SUM(user_seeks + user_scans + user_lookups) AS decimal) * 100 AS WriteRatio
FROM
    sys.dm_db_index_usage_stats