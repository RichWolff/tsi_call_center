SELECT
    "raw_hitwiseweeklyvisits"."date" + interval '1 days' AS "date", -- + one day to make it mon - sun
    EXTRACT(week FROM date)::integer as isoWeek,
    EXTRACT(MONTH from date)::integer as Month,
    EXTRACT(QUARTER FROM date)::integer as Quarter,
    EXTRACT(YEAR FROM date)::integer as Year,
    EXTRACT(isoYear FROM date)::integer as isoYear,
    "dim_brandInfo"."brandname" AS "brandname",
    "dim_brandInfo"."parentcompany" AS "parentcompany",
    "dim_brandInfo"."brandtype" AS "brandtype",
    "dim_brandInfo"."brandsubtype" AS "brandsubtype",
    "raw_hitwiseweeklyvisits"."value" AS "value"
FROM "public"."raw_hitwiseweeklyvisits" "raw_hitwiseweeklyvisits"
LEFT JOIN "public"."dim_hitwisenames" "dim_hitwiseNames" ON (CAST("raw_hitwiseweeklyvisits"."domain" AS TEXT) = CAST("dim_hitwiseNames"."raw_hitwiseweeklyvisits_domain" AS TEXT))
LEFT JOIN "public"."dim_brandinfo" "dim_brandInfo" ON ("dim_hitwiseNames"."comb_id" = "dim_brandInfo"."hitwise_comb_id")
WHERE brandstartdate <= '2017-01-01' and brandtype = 'manufacturer'
