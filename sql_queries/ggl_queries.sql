SELECT
  date,queryset,queries
FROM raw.raw_google_queries
WHERE
  queryset = 'Tempur-Pedic'
  AND date >= '2017-01-01'
