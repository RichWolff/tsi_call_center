DELETE FROM fact.fact_offlinemedia WHERE media_agency = 'Trilia' and channel ='TV';
insert into fact.fact_offlinemedia
SELECT
    tlm.weekbeginning weekBeginning,
    tlm.weekEnding weekEnding,
    tlm.mediaAgency mediaAgency,
    tlm.advertisedBrand advertisedBrand,
	'TV' channel,
    CASE
		WHEN tlm.estimate in ('DRT-181','TEP-CABL','TEP-CB2Q','DRT-182','TEI-SC2Q') THEN 'Cable TV'
		WHEN tlm.estimate = 'TEI-2NBA' THEN 'National TV'
		WHEN tlm.estimate = 'MORN' THEN 'Unwired Broadcast TV'
		ELSE 'Uncoded'
	END sub_channel,
    sum(CASE WHEN tlm.c3Ratings > tlm.overnightRatings THEN tlm.c3Ratings ELSE tlm.overnightRatings END) unequivalizedGRP,
    sum(CASE WHEN tlm.c3Impressions > tlm.overnightImpressions THEN tlm.c3Impressions ELSE tlm.overnightImpressions END) unequivalizedIMP,
    sum(tms.adSpend) adSpend,
    current_timestamp loadDate
FROM

    (SELECT
        week_of weekBeginning,
        dateadd(day,6,week_of) weekEnding,
        agency mediaAgency,
        product advertisedBrand,
		media_type,
        CASE estimate
            WHEN 'Morn' THEN 'MORN'
            ELSE estimate
        END estimate,
        sum(CASE WHEN type_of_demographic = 1 THEN act_ratings END) overnightRatings,
        sum(CASE WHEN type_of_demographic = 2 THEN act_ratings END) c3Ratings,
        sum(CASE WHEN type_of_demographic = 1 THEN act_impression END) overnightImpressions,
        sum(CASE WHEN type_of_demographic = 2 THEN act_impression END) c3Impressions
    FROM
        raw.raw_Trilia_LinearMedia
    GROUP BY
		week_of,
        dateadd(day,6,week_of),
        agency,
        product,
		media_type,
        CASE estimate
            WHEN 'Morn' THEN 'MORN'
            ELSE estimate
        END ) tlm

LEFT JOIN

    (SELECT
        week_of weekBeginning,
        dateadd(day,6,week_of) weekEnding,
        agency mediaAgency,
        advertiser advertisedBrand,
		media_type,
        est,
        sum(ordered) adSpend
    FROM raw.raw_Trilia_linearSpend
    GROUP BY week_of,dateadd(day,6,week_of),agency,advertiser,media_type,est) tms

ON
		tlm.weekBeginning = tms.weekBeginning
	AND tlm.advertisedBrand = tms.advertisedBrand
	AND tlm.estimate = tms.est
	AND tlm.media_type = tms.media_type
GROUP BY
    tlm.weekbeginning,
    tlm.weekEnding,
    tlm.mediaAgency,
    tlm.advertisedBrand,
	CASE
		WHEN tlm.estimate in ('DRT-181','TEP-CABL','TEP-CB2Q','DRT-182','TEI-SC2Q') THEN 'Cable TV'
		WHEN tlm.estimate = 'TEI-2NBA' THEN 'National TV'
		WHEN tlm.estimate = 'MORN' THEN 'Unwired Broadcast TV'
		ELSE 'Uncoded'
	END
