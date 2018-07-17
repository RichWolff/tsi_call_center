SELECT
	cid_brand.cid,
	r.start_date::date,
	r.end_date::date,
	cid_brand.brands,
        r.segment_id::char(1),
	r.weight cid_weight,
	r.n12_flag*r.weight n12_weighted,
	r.p12_flag*r.weight p12_weighted,
	r.s2cq10_1 shopping_channel,
	r.s2cq10_2 purchase_channel,

	/* BUILD n12 consideration by brand */
	CASE cid_brand.brands
    WHEN 'Tempur-Pedic' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_1,0) + COALESCE(n12.s2bq30p2_1_1,0) + COALESCE(n12.s2bq30p3_1_1,0) + COALESCE(n12.s2bq30p4_1_1,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Sealy' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_2,0) + COALESCE(n12.s2bq30p2_1_2,0) + COALESCE(n12.s2bq30p3_1_2,0) + COALESCE(n12.s2bq30p4_1_2,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Stearns & Foster' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_3,0) + COALESCE(n12.s2bq30p2_1_3,0) + COALESCE(n12.s2bq30p3_1_3,0) + COALESCE(n12.s2bq30p4_1_3,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Serta' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_4,0) + COALESCE(n12.s2bq30p2_1_4,0) + COALESCE(n12.s2bq30p3_1_4,0) + COALESCE(n12.s2bq30p4_1_4,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Simmons/Beautyrest' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_5,0) + COALESCE(n12.s2bq30p2_1_5,0) + COALESCE(n12.s2bq30p3_1_5,0) + COALESCE(n12.s2bq30p4_1_5,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Sleep Number' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_6,0) + COALESCE(n12.s2bq30p2_1_6,0) + COALESCE(n12.s2bq30p3_1_6,0) + COALESCE(n12.s2bq30p4_1_6,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'IKEA' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_7,0) + COALESCE(n12.s2bq30p2_1_7,0) + COALESCE(n12.s2bq30p3_1_7,0) + COALESCE(n12.s2bq30p4_1_7,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Dormeo' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_8,0) + COALESCE(n12.s2bq30p2_1_8,0) + COALESCE(n12.s2bq30p3_1_8,0) + COALESCE(n12.s2bq30p4_1_8,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Hampton and Rhodes' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_9,0) + COALESCE(n12.s2bq30p2_1_9,0) + COALESCE(n12.s2bq30p3_1_9,0) + COALESCE(n12.s2bq30p4_1_9,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Restonic' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_10,0) + COALESCE(n12.s2bq30p2_1_10,0) + COALESCE(n12.s2bq30p3_1_10,0) + COALESCE(n12.s2bq30p4_1_10,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'The Dream Bed' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_11,0) + COALESCE(n12.s2bq30p2_1_11,0) + COALESCE(n12.s2bq30p3_1_11,0) + COALESCE(n12.s2bq30p4_1_11,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Saatva' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_12,0) + COALESCE(n12.s2bq30p2_1_12,0) + COALESCE(n12.s2bq30p3_1_12,0) + COALESCE(n12.s2bq30p4_1_12,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Casper' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_13,0) + COALESCE(n12.s2bq30p2_1_13,0) + COALESCE(n12.s2bq30p3_1_13,0) + COALESCE(n12.s2bq30p4_1_13,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Tuft & Needle' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_14,0) + COALESCE(n12.s2bq30p2_1_14,0) + COALESCE(n12.s2bq30p3_1_14,0) + COALESCE(n12.s2bq30p4_1_14,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Cocoon by Sealy' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_15,0) + COALESCE(n12.s2bq30p2_1_15,0) + COALESCE(n12.s2bq30p3_1_15,0) + COALESCE(n12.s2bq30p4_1_15,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Leesa' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_16,0) + COALESCE(n12.s2bq30p2_1_16,0) + COALESCE(n12.s2bq30p3_1_16,0) + COALESCE(n12.s2bq30p4_1_16,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'King Koil' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_17,0) + COALESCE(n12.s2bq30p2_1_17,0) + COALESCE(n12.s2bq30p3_1_17,0) + COALESCE(n12.s2bq30p4_1_17,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Kluft' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_18,0) + COALESCE(n12.s2bq30p2_1_18,0) + COALESCE(n12.s2bq30p3_1_18,0) + COALESCE(n12.s2bq30p4_1_18,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'SpringAir' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_19,0) + COALESCE(n12.s2bq30p2_1_19,0) + COALESCE(n12.s2bq30p3_1_19,0) + COALESCE(n12.s2bq30p4_1_19,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Purple' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_20,0) + COALESCE(n12.s2bq30p2_1_20,0) + COALESCE(n12.s2bq30p3_1_20,0) + COALESCE(n12.s2bq30p4_1_20,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Loom & Leaf by Saatva' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_21,0) + COALESCE(n12.s2bq30p2_1_21,0) + COALESCE(n12.s2bq30p3_1_21,0) + COALESCE(n12.s2bq30p4_1_21,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Helix Sleep' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_22,0) + COALESCE(n12.s2bq30p2_1_22,0) + COALESCE(n12.s2bq30p3_1_22,0) + COALESCE(n12.s2bq30p4_1_22,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'SleepHäus' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_23,0) + COALESCE(n12.s2bq30p2_1_23,0) + COALESCE(n12.s2bq30p3_1_23,0) + COALESCE(n12.s2bq30p4_1_23,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'Other' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_24,0) + COALESCE(n12.s2bq30p2_1_24,0) + COALESCE(n12.s2bq30p3_1_24,0) + COALESCE(n12.s2bq30p4_1_24,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'A specific brand that I do not remember' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_25,0) + COALESCE(n12.s2bq30p2_1_25,0) + COALESCE(n12.s2bq30p3_1_25,0) + COALESCE(n12.s2bq30p4_1_25,0)) >= 1 THEN r.weight ELSE 0 END
    WHEN 'A brand I have not yet determined' THEN
    	CASE WHEN (COALESCE(n12.s2bq30p1_1_26,0) + COALESCE(n12.s2bq30p2_1_26,0) + COALESCE(n12.s2bq30p3_1_26,0) + COALESCE(n12.s2bq30p4_1_26,0)) >= 1 THEN r.weight ELSE 0 END
    ELSE 0
  END n12_consideration,

  /* BUILD n12 PRIMARY consideration by brand */
  CASE cid_brand.brands
    WHEN 'Tempur-Pedic' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  1 OR COALESCE(n12.S2BQ30P2_2,0) = 1 OR COALESCE(n12.S2BQ30P3_2,0)  = 1 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Sealy' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  2 OR COALESCE(n12.S2BQ30P2_2,0) = 2 OR COALESCE(n12.S2BQ30P3_2,0)  = 2 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Stearns & Foster' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  3 OR COALESCE(n12.S2BQ30P2_2,0) = 3 OR COALESCE(n12.S2BQ30P3_2,0)  = 3 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Serta' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  4 OR COALESCE(n12.S2BQ30P2_2,0) = 4 OR COALESCE(n12.S2BQ30P3_2,0)  = 4 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Simmons/Beautyrest' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  5 OR COALESCE(n12.S2BQ30P2_2,0) = 5 OR COALESCE(n12.S2BQ30P3_2,0)  = 5 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Sleep Number' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  6 OR COALESCE(n12.S2BQ30P2_2,0) = 6 OR COALESCE(n12.S2BQ30P3_2,0)  = 6 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'IKEA' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  7 OR COALESCE(n12.S2BQ30P2_2,0) = 7 OR COALESCE(n12.S2BQ30P3_2,0)  = 7 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Dormeo' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  8 OR COALESCE(n12.S2BQ30P2_2,0) = 8 OR COALESCE(n12.S2BQ30P3_2,0)  = 8 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Hampton and Rhodes' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  9 OR COALESCE(n12.S2BQ30P2_2,0) = 9 OR COALESCE(n12.S2BQ30P3_2,0)  = 9 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Restonic' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  10 OR COALESCE(n12.S2BQ30P2_2,0) = 10 OR COALESCE(n12.S2BQ30P3_2,0)  = 10 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'The Dream Bed' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  11 OR COALESCE(n12.S2BQ30P2_2,0) = 11 OR COALESCE(n12.S2BQ30P3_2,0)  = 11 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Saatva' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  12 OR COALESCE(n12.S2BQ30P2_2,0) = 12 OR COALESCE(n12.S2BQ30P3_2,0)  = 12 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Casper' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  13 OR COALESCE(n12.S2BQ30P2_2,0) = 13 OR COALESCE(n12.S2BQ30P3_2,0)  = 13 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Tuft & Needle' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  14 OR COALESCE(n12.S2BQ30P2_2,0) = 14 OR COALESCE(n12.S2BQ30P3_2,0)  = 14 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Cocoon by Sealy' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  15 OR COALESCE(n12.S2BQ30P2_2,0) = 15 OR COALESCE(n12.S2BQ30P3_2,0)  = 15 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Leesa' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  16 OR COALESCE(n12.S2BQ30P2_2,0) = 16 OR COALESCE(n12.S2BQ30P3_2,0)  = 16 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'King Koil' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  17 OR COALESCE(n12.S2BQ30P2_2,0) = 17 OR COALESCE(n12.S2BQ30P3_2,0)  = 17 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Kluft' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  18 OR COALESCE(n12.S2BQ30P2_2,0) = 18 OR COALESCE(n12.S2BQ30P3_2,0)  = 18 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'SpringAir' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  19 OR COALESCE(n12.S2BQ30P2_2,0) = 19 OR COALESCE(n12.S2BQ30P3_2,0)  = 19 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Purple' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  20 OR COALESCE(n12.S2BQ30P2_2,0) = 20 OR COALESCE(n12.S2BQ30P3_2,0)  = 20 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Loom & Leaf by Saatva' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  21 OR COALESCE(n12.S2BQ30P2_2,0) = 21 OR COALESCE(n12.S2BQ30P3_2,0)  = 21 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Helix Sleep' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  22 OR COALESCE(n12.S2BQ30P2_2,0) = 22 OR COALESCE(n12.S2BQ30P3_2,0)  = 22 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'SleepHäus' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  23 OR COALESCE(n12.S2BQ30P2_2,0) = 23 OR COALESCE(n12.S2BQ30P3_2,0)  = 23 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'Other' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  24 OR COALESCE(n12.S2BQ30P2_2,0) = 24 OR COALESCE(n12.S2BQ30P3_2,0)  = 24 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'A specific brand that I do not remember' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  25 OR COALESCE(n12.S2BQ30P2_2,0) = 25 OR COALESCE(n12.S2BQ30P3_2,0)  = 25 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    WHEN 'A brand I have not yet determined' THEN
      CASE WHEN (COALESCE(n12.S2BQ30P1_2,0) =  26 OR COALESCE(n12.S2BQ30P2_2,0) = 26 OR COALESCE(n12.S2BQ30P3_2,0)  = 26 OR COALESCE(n12.S2BQ30P4_2,0) =1) THEN r.weight ELSE 0 END
    ELSE 0
  END n12_primary_consideration,
  unaided_data.unaided_awareness_any,
  unaided_data.unaided_awareness_top3,
  unaided_data.unaided_awareness_top1,
  unaided_data.unaided_brands_count
FROM
  /* Make a brand option for every user and join to brand tracker tables */
  (
    (select distinct cid
    from raw_brandtracker_respondentdata) cids
  CROSS JOIN
    (select unnest('{Tempur-Pedic, Sealy, Stearns & Foster, Serta, Simmons/Beautyrest, Sleep Number, IKEA,
    				 Dormeo, Hampton and Rhodes, Restonic, The Dream Bed, Saatva, Casper, Tuft & Needle,
    				 Cocoon by Sealy, Leesa, King Koil, Kluft, SpringAir, Purple, Loom & Leaf by Saatva,
    				 Helix Sleep, SleepHäus, Other, A specific brand that I do not remember, A brand I have not yet determined}'::text[]) brands ) brands
  ) cid_brand
LEFT JOIN
  raw_brandtracker_respondentdata r
ON
  cid_brand.cid = r.cid
LEFT JOIN
  raw_brandtracker_n12intent n12
ON
  cid_brand.cid = n12.cid
LEFT JOIN
  (SELECT
  	brands.cid,
  	brands.brands,
  	CASE WHEN awareness_order between 1 and 3 THEN weight else 0 end unaided_awareness_top3,
  	CASE WHEN awareness_order = 1 THEN weight else 0 end unaided_awareness_top1,
  	CASE WHEN awareness_order >= 1 THEN weight else 0 end unaided_awareness_any,
	  count(*) over (partition by brands.cid) unaided_brands_count
  FROM
  	(SELECT
	 	cid,
		weight,
	 	mapped,
	 	orig_order,
	 	awareness_order,
	    row_number() over (partition by cid,mapped order by cid,mapped,orig_order) brand_count
	FROM
    (SELECT
    	unnested.cid,
		unnested.weight,
    	unnested.unaided_responses,
    	umap.mapped,
	    row_number() over () orig_order,
    	row_number() over (partition by unnested.cid) awareness_order
    FROM
      (SELECT
      	cid,
		weight,
      	unnest(string_to_array(s80,'<>')::text[]) unaided_responses

      FROM
      (SELECT
      	mb.cid, mb.s80,r.weight
      FROM raw_brandtracker_mattressbrands mb
	  LEFT JOIN raw_brandtracker_respondentdata r
	  ON mb.cid = r.cid
      ORDER BY cid) raw_unaided ) unnested
      LEFT JOIN
      	dim_brandtracker_unaidedmap umap
      ON
      unnested.unaided_responses = umap.unaided) unaided ) final_unaided
    RIGHT JOIN
      (select * from
      (select distinct cid
          from raw_brandtracker_respondentdata) cids
        CROSS JOIN
          (select unnest('{Tempur-Pedic, Sealy, Stearns & Foster, Serta, Simmons/Beautyrest, Sleep Number, IKEA,
          				 Dormeo, Hampton and Rhodes, Restonic, The Dream Bed, Saatva, Casper, Tuft & Needle,
          				 Cocoon by Sealy, Leesa, King Koil, Kluft, SpringAir, Purple, Loom & Leaf by Saatva,
          				 Helix Sleep}'::text[]) brands ) brands) brands
      on final_unaided.cid = brands.cid AND final_unaided.mapped = brands.brands
WHERE final_unaided.brand_count = 1) unaided_data
ON
  cid_brand.cid = unaided_data.cid
  and cid_brand.brands = unaided_data.brands
ORDER BY end_date, brands desc
