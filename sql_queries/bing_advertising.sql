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
	sum(clicks) clicks
FROM
(SELECT
    date,
		CASE
			WHEN campaign_name like '%display%' and campaign_name like '%acq%' THEN 'Display Acquisition'
			WHEN campaign_name like '%display%' and campaign_name like '%rm%' THEN 'Display Remarketing'
			WHEN campaign_name like '%non-brand%' THEN 'Non-Branded Search'
			WHEN campaign_name like '%Brand%' THEN 'Branded Search'
			WHEN campaign_name like '%Competitor%' THEN 'Competitor Search'
			WHEN campaign_name like '%lal%' OR campaign_name like '%acquisition%' THEN 'Acquisition'
			WHEN campaign_name like '%Shopping%' THEN 'Shopping'
			WHEN campaign_name like '%DPA%' OR campaign_name like '%visitor%' THEN 'Remarketing'
			WHEN campaign_name like '%retargeting%' OR campaign_name like '%cart%' OR campaign_name like '%remarketing%' OR campaign_name like '%RM%' THEN 'Remarketing'
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
  clicks
FROM
	[raw].[raw_thrive_bing]
WHERE
	advertiser = 'Tempur-Pedic') raw
GROUP BY
	date,
	channel_group,
	product_group,
  sub_channel,
	advertiser
