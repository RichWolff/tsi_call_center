SELECT
  date,
  datepart(mm,dateadd(HH,-5,date)) [month],
  datepart(yyyy,dateadd(HH,-5,date)) [year],
  datepart(isoww,dateadd(HH,-5,date)) [isoweek],
  (datepart(dw,dateadd(HH,-5,date)) + 5) % 7 + 1 [isodow],
  YEAR(DATEADD(day, 26 - DATEPART(isoww, dateadd(HH,-5,date)), dateadd(HH,-5,date))) [isoyear],
  network,
  channel_group,
  sub_channel,
  advertiser,
  sum(cost) cost,
  sum(impressions) impressions,
  sum(clicks) clicks,
  sum(video_views) video_views,
  sum(post_comments) post_comments,
  sum(post_likes) post_likes,
  sum(post_reactions) post_reactions
FROM
  (
  SELECT
    date,
    CASE
      WHEN campaign_name like '%IG%' or campaign_name like '%Ig%' or campaign_name like '%ig%' then 'Instagram'
      ELSE 'Facebook'
    END network,
  	CASE
  		WHEN campaign_name like '%acq%' or campaign_name like '%ACQ%' THEN 'Acquisition'
  		WHEN campaign_name like '%display&' AND campaign_name like '%rm%' THEN 'Remarketing'
  		WHEN campaign_name like '%non-brand&' THEN 'Non-Branded Search'
  		WHEN campaign_name like '%Brand%' THEN 'Branded Search'
  		WHEN campaign_name like '%Competitor&' THEN 'Competitor'
  		WHEN campaign_name like '%lal%' OR campaign_name like '%acquisition%' THEN 'Acquisition'
  		WHEN campaign_name like '%Shopping%' THEN 'Shopping'
  		WHEN campaign_name like '%DPA%' OR campaign_name like '%visitor%' THEN 'Remarketing'
  		WHEN campaign_name like '%retargeting%' OR campaign_name like '%cart%' OR campaign_name like '%remarketing%' OR campaign_name like '%RM%' OR campaign_name like '%RTG%' THEN 'Remarketing'
  		ELSE 'Acquisition'
  	END channel_group,
  	sub_channel,
    advertiser,
    cost,
    impressions,
    clicks,
    video_views,
    post_comments,
  	post_likes,
  	post_reactions
  FROM
  	[raw].[raw_thrive_facebook]
  WHERE
    advertiser = 'Tempur-Pedic'
) raw
GROUP BY
  date,
  network,
  channel_group,
  sub_channel,
  advertiser
