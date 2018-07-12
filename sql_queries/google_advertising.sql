SELECT
	date,
	datepart(mm,dateadd(HH,-5,date)) [month],
	datepart(yyyy,dateadd(HH,-5,date)) [year],
	datepart(isoww,dateadd(HH,-5,date)) [isoweek],
	(datepart(dw,dateadd(HH,-5,date)) + 5) % 7 + 1 [isodow],
	YEAR(DATEADD(day, 26 - DATEPART(isoww, dateadd(HH,-5,date)), dateadd(HH,-5,date))) [isoyear],
	channel_group,
	product_group,
	sub_channel,
	advertiser,
	sum(cost) cost,
	sum(impressions) impressions,
	sum(clicks) clicks,
	sum(video_views) video_views,
	sum(video_completes) video_completes
FROM
(SELECT
    date,
    CASE
      WHEN campaign_name like '%MFRM%' THEN 'Mattress Firm'
      WHEN campaign_name like '%youtube%' or campaign_name like '%video%' THEN 'YouTube'
      WHEN (NOT campaign_name like 'Display') AND ((campaign_name like '%generic |%' or campaign_name like '%non-brand%' or campaign_name like '%nonbrand%') and campaign_name like '%Tier 1%') THEN 'Non-Branded Search Tier 1'
      WHEN (NOT campaign_name like 'Display') AND ((campaign_name like '%generic |%' or campaign_name like '%non-brand%' or campaign_name like '%nonbrand%') and NOT campaign_name like '%Tier 1%') THEN 'Non-Branded Search'
      WHEN (campaign_name like '%display%' or campaign_name like '%Display%') AND (campaign_name like '%similar%' or campaign_name like '%contextual%' or campaign_name like '%int%' or campaign_name like '%acq%') THEN 'Display Acquisition'
      WHEN campaign_name like '%competitor%' or campaign_name like '%conquesting%' then 'Competitor'
      WHEN (campaign_name like '%retargeting%' or campaign_name like '%remarketing%' or campaign_name like '%RLSA%' or campaign_name like '%RM%') AND campaign_name like '%dynamic%' THEN 'Dynamic Remarketing'
      WHEN (campaign_name like '%retargeting%' or campaign_name like '%remarketing%' or campaign_name like '%RLSA%' or campaign_name like '%RM%') AND NOT campaign_name like '%dynamic%' THEN 'Remarketing'
      WHEN campaign_name like '%brand |%' or campaign_name like '%Search%' or campaign_name like '%proper%'or campaign_name like '%branded%' THEN 'Branded Search'
      WHEN campaign_name like '%Shopping%' THEN 'Shopping'
  	ELSE campaign_name
    END channel_group,
	CASE
		WHEN (campaign_name like '%youtube%' or campaign_name like '%video%') or sub_channel = 'YouTube Videos' THEN 'YT'
		WHEN sub_channel = 'Display Network' THEN 'DN'
		WHEN sub_channel = 'Search Network' THEN 'SN'
		ELSE sub_channel
	END sub_channel,
	CASE
		WHEN campaign_name like '%pillow%' or campaign_name like '%pillows%' THEN 'Pillow'
		WHEN campaign_name like '%Mattress&' or campaign_name like '%mattress%' then 'Mattress'
		ELSE 'Other'
	END product_group,
  advertiser,
  cost,
  impressions,
  clicks,
  video_views,
  video_completes
FROM
	[raw].[raw_thrive_google]
WHERE
	advertiser = 'Tempur-Pedic') raw
GROUP BY
	date,
	channel_group,
	product_group,
  sub_channel,
	advertiser
