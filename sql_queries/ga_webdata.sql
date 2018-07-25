SELECT
  level1.*,
  CASE
  	WHEN level1.medium = 'cpc' and level1.source in ('facebook-instagram','facebook','instagram','pinterest','facebook-remarketing') THEN 'digital_cpc_social'
	WHEN level1.medium = 'cpc' and level1.source in ('google','bing') THEN 'digital_cpc_search'
	WHEN level1.medium = 'cpc' and level1.source in ('pandora','spotify') THEN 'digital_cpc_audio'
	WHEN level1.medium = 'cpc' and level1.source in ('hulu','roku','googlepreferred') THEN 'digital_cpc_video'
	WHEN level1.medium in ('organic','(none)') THEN 'organic-direct'
	WHEN level1.medium = 'referral' and level1.source in ('tempurpillows.com','tempurpedicsale.com','tempur.com','sealy.com','tempursealy.com') THEN 'referral_tsi_site'
	WHEN level1.medium = 'referral' and level1.source in ('youtube.com') THEN 'referral_digital_video'
	WHEN (level1.medium = 'referral' and level1.source in ('thesleepjudge.com','sleepopolis.com','memoryfoamtalk.com')) or level1.medium = 'HONESTMATTRESSREVIEWS.COM' THEN 'referral_review_sites'
	WHEN level1.medium = 'email' then 'digital_email'
	WHEN level1.medium = 'display' then 'digital_display'
	WHEN level1.medium = 'tv' then 'tv'
	ELSE 'digital_other'
  END srcmed_group,
  CASE WHEN level1.medium in ('organic','cpc') and level1.source = 'google' THEN level1.total_sessions else 0 end sessions_from_google_search,
  EXTRACT(week FROM level1.date)::integer as isoWeek,
  EXTRACT(MONTH from level1.date)::integer as Month,
  EXTRACT(QUARTER FROM level1.date)::integer as Quarter,
  EXTRACT(YEAR FROM level1.date)::integer as Year,
  EXTRACT(isoYear FROM level1.date)::integer as isoYear,
  coalesce(level2.basket_uniquepageviews,0) basket_uniquepageviews,
  coalesce(level2.checkout_uniquepageviews,0) checkout_unqiuepageviews,
  coalesce(level2.mattress_reviews_uniquepageviews,0) mattress_reviews_uniquepageviews,
  coalesce(level2.pillow_reviews_uniquepageviews,0) pillow_reviews_uniquepageviews
FROM
(SELECT
	gadate date,
	tsibrand brand,
	tsiwebsite website,
	gamedium medium,
	gasource source,
	sum(gasessions) total_sessions,
	sum(gapageviews) total_pageviews,
	sum(gauniquepageviews) total_unique_pageviews,
	sum(gasessionduration) total_session_duration,
  sum(CASE WHEN gapagepathlevel1 like '%retail%' or gapagepathlevel1 like '%locat%' THEN gapageviews else 0 END) locator_pageviews,
	sum(CASE WHEN gapagepathlevel1 like '%retail%' or gapagepathlevel1 like '%locat%' THEN gauniquepageviews else 0 END) locator_uniquepageviews,
	sum(CASE WHEN (gapagepathlevel1 like '%mattress%' AND NOT lower(gapagepathlevel1) similar to ('%warranty|topper%')) or gapagepathlevel1 like '%collection%' THEN gapageviews else 0 END) mattress_category_pageviews,
  sum(CASE WHEN (gapagepathlevel1 like '%mattress%' AND NOT lower(gapagepathlevel1) similar to ('%warranty|topper%')) or gapagepathlevel1 like '%collection%' THEN gauniquepageviews else 0 END) mattress_category_pageviews,
	sum(CASE WHEN gapagepathlevel1 like '%pillow%' THEN gapageviews else 0 END) pillow_category_pageviews,
  sum(CASE WHEN gapagepathlevel1 like '%pillow%' THEN gauniquepageviews else 0 END) pillow_category_uniquepageviews,
	sum(CASE WHEN gapagepathlevel1 like '%offers%' or gapagepathlevel1 like '%promotion%' THEN gapageviews else 0 END) offers_pageviews,
  sum(CASE WHEN gapagepathlevel1 like '%offers%' or gapagepathlevel1 like '%promotion%' THEN gauniquepageviews else 0 END) offers_uniquepageviews,
	sum(CASE WHEN gapagepathlevel1 like '%review%' THEN gapageviews else 0 END) reviews_pageviews,
  sum(CASE WHEN gapagepathlevel1 like '%review%' THEN gauniquepageviews else 0 END) reviews_uniquepageviews
FROM raw_gacampaign gaca
LEFT JOIN dim_gaviews gavw
ON (gaca.gaviewnumber = gavw.gaviewnumber AND ((gaca.gadate >= gavw.startdate) AND ((gaca.gadate<=gavw.enddate) or (gavw.enddate is null))))
WHERE gaca.gadate >= '2017-01-01' and tsiwebsite = 'tempurpedic.com'
GROUP BY gadate,tsibrand, tsiwebsite, gamedium, gasource) level1

LEFT JOIN

(SELECT
	gadate date,
	tsibrand brand,
	tsiwebsite website,
	substring(gasourcemedium,'[A-Za-z0-9()]*[^ / ]') source,
	substring(gasourcemedium,'[^/ ]*$') medium,
 	sum(CASE WHEN gapagepathlevel1 like '%reviews%' AND gapagepathlevel2 like '%mattress%' THEN gauniquepageviews else 0 END) mattress_reviews_uniquepageviews,
	sum(CASE WHEN gapagepathlevel1 like '%reviews%' AND gapagepathlevel2 like '%pillows%' THEN gauniquepageviews else 0 END) pillow_reviews_uniquepageviews,
  sum(CASE WHEN gapagepathlevel1 like '%store%' AND gapagepathlevel2 like '%basket%' THEN gauniquepageviews else 0 END) basket_uniquepageviews,
	sum(CASE WHEN gapagepathlevel1 like '%store%' AND gapagepathlevel2 like '%checkout%' THEN gauniquepageviews else 0 END) checkout_uniquepageviews
FROM
 	raw_gamedia gaca
LEFT JOIN
 	dim_gaviews gavw
ON
 	(gaca.gaviewnumber = gavw.gaviewnumber AND ((gaca.gadate >= gavw.startdate) AND ((gaca.gadate<=gavw.enddate) or (gavw.enddate is null))))
WHERE gaca.gadate >= '2017-01-01' and tsiwebsite = 'tempurpedic.com'
GROUP BY
 	gadate,tsibrand, tsiwebsite, substring(gasourcemedium,'[A-Za-z0-9()]*[^ / ]'), substring(gasourcemedium,'[^/ ]*$')) level2
ON
  level1.date = level2.date and level1.brand = level2.brand and level1.website = level2.website and level1.medium = level2.medium and
  level1.source = level2.source
--where lower(level1.utm_campaign) in (SELECT DISTINCT utm_campaign FROM dim_trilia_onlinegaterms)
