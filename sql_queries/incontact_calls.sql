WITH call_center_CTE (
	contact_id, master_contact_id, contact_code, media_name, contact_name, ani_dialnum,
	skill_num, skill_name, skill2, campaign_no, campaign_name, agent_no, agent_name, team_no, team_name,
	sla, start_datetime, prequeue, inqueue, agent_time, postqueue, acw_time, total_time_plus_disposition,
	abandon_time, routing_time, abandon, callback_time, logged, hold_time, disposition_code, disposition_name,
	disposition_comments, tags)
AS (
	SELECT
	  [contact_id]  ,[master_contact_id]  ,[contact_code]  ,[media_name]
	  ,[contact_name]  ,[ani_dialnum]  ,[skill_no]  ,[skill_name] , CASE WHEN skill_name in ('Direct Sales','Direct Sales - OB', 'DTC Sales - OB') THEN 'DTC' ELSE skill_name END skill2
	  ,[campaign_no]	  ,[campaign_name]  ,[agent_no]  ,[agent_name]  ,[team_no]  ,[team_name]
	  ,[sla]  ,[start_datetime]  ,sum(prequeue) prequeue  ,sum(inqueue) inqueue
	  ,sum(agent_time) agent_time  ,sum(postqueue) postqueue  ,sum(acw_time) acw_time
	  ,sum(total_time_plus_disposition) total_time_plus_disposition  ,sum(abandon_time) abandon_time
	  ,sum(routing_time) routing_time  ,abandon  ,sum(callback_time) callback_time ,logged  ,sum(hold_time) hold_time
	  ,disposition_code  ,disposition_name  ,disposition_comments  ,tags
	FROM
	  raw.raw_incontact_callcenter
	GROUP BY
	  [contact_id]  ,[master_contact_id]  ,[contact_code]  ,[media_name]  ,[contact_name]  ,[ani_dialnum]
	  ,[skill_no]  ,[skill_name]  ,CASE WHEN skill_name in ('Direct Sales','Direct Sales - OB', 'DTC Sales - OB') THEN 'DTC' else skill_name END
	  ,[campaign_no]  ,[campaign_name]  ,[agent_no]  ,[agent_name]  ,[team_no]
	  ,[team_name]  ,[sla]  ,[start_datetime], logged, abandon	,disposition_code  ,disposition_name
	  ,disposition_comments  ,tags
)

SELECT
	[date],[month],[year],[isoweek],[isodow],[isoyear], --dates
	call_grouping,
	count(*) calls,
	sum(CASE WHEN master_contact_num_by_ani = 1 then 1 else 0 end) first_contacts,
	sum(CASE WHEN master_contact_num_by_ani >= 2  and time_since_last_contact > 1 then 1 else 0 end) second_contacts
FROM
(SELECT
	call_center_CTE.master_contact_id,
	row_number() over (partition by master_contact_id order by master_contact_id,contact_id) master_contact_rownum,
	row_number() over (partition by master_contact_id,skill_name order by master_contact_id,skill_name,contact_id) master_contact_rownum_dsonly,
	call_center_CTE.contact_id,
	call_center_CTE.contact_name,
	CASE
		--DTC DIRECT MAIL
		WHEN contact_name in ('8007900483','8884471753','8885522088','8888252551','8004017561','8004991824','8004991846','8004993920','8883179074','8883368950','8004017567','8006948303','8007900474','8004018170','8006881552','8006948305','8882383091','8004017527','8006948280','8007900094','8885522080','8885524221','8883367198','8007207361','8008949894','8004018075','8004991823','8883368249','8885232134','8885462596') THEN 'DTCSales_DirectMail'
		--DTC Sales
		WHEN contact_name in ('8663570087','8885232517','8008866466','8884761625','8883363916','8884474053','8882667888','8882257894','8882259345','8882258380','8008384410','8007422764','8885018234','8882257974','8007066787','8004017518','8882259478','8008703619','8008818748','8888866228','8008245643','8008381504','8882258020','8883179158','8004017521','8006248549','8006881859','8006948296','8007900182','8882257564','8008949560','8882490282','8004991988','8007901027','8665738487','8667959367','8885520606','8888332646','8004993921','8006948306','8007900147','8882259277','8883165283','8883177067','8003719478','8003680802','8883369017') THEN 'DTCSales'
		--DTC EMAIL
		WHEN contact_name in ('8882258610','8883364764','8883170295','8007048755','8882257962','8008067692','8882257984','8004334508','8882257953','8009525125','8662834074','8004330762','8662392779','8008132965','8882258711','8007900463','8882257987','8882257989','8882258066','8004991831','8882258049','8882258064','8883363972','8882258013','8882258092') THEN 'DTCSales_Email'
		--DTC Website Sales
		WHEN contact_name in ('8446836787','8888115053') THEN 'DTCSales_Website'
		--DTCSALES Paid search
		WHEN contact_name = '8007110913' THEN 'DTCSales_PaidSearch'
		WHEN contact_name = '8007455697' THEN 'DTCSales_Pillows'
		WHEN contact_name = '8448683678' THEN 'DTCSales_SalesSite'
		WHEN contact_name in ('8007207419','8008066409','8008382304','8887327772') THEN 'DTCSales_Product'
		WHEN contact_name in ('8006445826','8008940048','8882259692','8885659315') THEN 'DTCSales_NA'
		WHEN contact_name = '8882455109' THEN 'DTCSales_Radio'
		WHEN contact_name = '8885527917' THEN 'DTCSales_TopperSite'
		WHEN contact_name = '8009521163' THEN 'DTCSales_Social'
		WHEN contact_name = '8885038832' THEN 'DTCSales_TV'
		WHEN contact_name = '8663714822' THEN 'DTCSales_PR'
		WHEN contact_name = '8882258610' THEN 'DTCSales_Display'
		--DTC General CS
		--WHEN contact_name in ('8005108323','8005246621','8008246621') THEN 'Tempur_GeneralCS'
		--ELSE 'Other'
	END call_grouping,
	call_center_CTE.ani_dialnum,
	call_center_CTE.skill_name,
	call_center_CTE.skill2,
	call_center_CTE.campaign_name,
	call_center_CTE.start_datetime,
	cast(call_center_CTE.start_datetime as date) [date],
	datepart(mm,dateadd(HH,-5,start_datetime)) [month],
	datepart(yyyy,dateadd(HH,-5,start_datetime)) [year],
	datepart(isoww,dateadd(HH,-5,start_datetime)) [isoweek],
	(datepart(dw,dateadd(HH,-5,start_datetime)) + 5) % 7 + 1 [isodow],
	YEAR(DATEADD(day, 26 - DATEPART(isoww, dateadd(HH,-5,start_datetime)), dateadd(HH,-5,start_datetime))) [isoyear],
	call_center_CTE.media_name,
	datediff(ss,lag(start_datetime) over (partition by ani_dialnum, skill2 order by ani_dialnum, skill2, start_datetime),start_datetime)/60./60./24. time_since_last_contact,
	dense_rank() over (partition by ani_dialnum  order by master_contact_id) master_contact_num_by_ani,
	call_center_CTE.agent_time,
	abandon,
	disposition_name
FROM call_center_CTE) raw
WHERE skill_name = 'Direct Sales' and master_contact_rownum_dsonly = 1
GROUP BY
	[date],[month],[year],[isoweek],[isodow],[isoyear], --dates
	call_grouping
ORDER BY [date],[call_grouping]
