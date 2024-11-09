UPDATE "DwSales".product_dim pd
SET
    "current" = false,
    "expiredDate" = current_timestamp
FROM
    "StgSales".productcategory_stg pc
JOIN "StgSales".productgrouplevel4_stg p4
    ON p4."ProductCategoryID" = pc."ProductCategoryID"
JOIN "StgSales".productgrouplevel3_stg p3
    ON p3."ProductLevel3ID" = p4."ProductLevel3ID"
JOIN "StgSales".productgrouplevel2_stg p2
    ON p2."ProductLevel2ID" = p3."ProductLevel2ID"
JOIN "StgSales".productgrouplevel1_stg p1
    ON p1."ProductLevel1ID" = p2."ProductLevel1ID"
WHERE
    pd."current" = true
    AND pd."ProductLevel4Code" = p4."ProductLevel4Code"
    AND (
        regexp_replace(pd."ProductCategoryDesc", '(Mc|mc)', '') != pc."ProductCategoryDesc"
        AND pd."ProductLevel1Desc" != p1."ProductLevel1Desc"
       	AND pd."ProductLevel2Desc" != p2."ProductLevel2Desc"
        AND pd."ProductLevel3Desc" != p3."ProductLevel3Desc"
        AND regexp_replace(pd."ProductLevel4Desc", '(Mc|mc|mac|Mac)', 'bac') != p4."ProductLevel4Desc"
    );


--insert 
INSERT INTO "DwSales".product_dim (
 	"productId",
    "ProductLevel4Code",
    "ProductCategoryDesc",
    "ProductLevel1Desc",
    "ProductLevel2Desc",
    "ProductLevel3Desc",
    "ProductLevel4Desc",
    "StartDate",
    "batchID",
    "loadingTime" ,
    "effectiveDate",
    current,
    "expiredDate"
)
select DISTINCT
    nextval('"DwSales"."product_dim_productId_seq"') AS "productId",
    p4."ProductLevel4Code",
    regexp_replace(pc."ProductCategoryDesc", '(Mc|mc)', '') AS "ProductCategoryDesc",
    p1."ProductLevel1Desc",
    p2."ProductLevel2Desc",
    p3."ProductLevel3Desc",
    regexp_replace(p4."ProductLevel4Desc", '(Mc|mc|mac|Mac)', 'bac') AS "ProductLevel4Desc",
    COALESCE(pc."StartDate", p1."StartDate", p2."StatDate", p3."StartDate", p4."StartDate") AS "StartDate",
    pc."batchID",
    pc."loadingTime",
    current_timestamp::date AS "effectiveDate",
    true AS current,
    NULL::timestamp AS "expiredDate"
FROM
    "StgSales".productcategory_stg pc
join "StgSales".productgrouplevel4_stg p4
	on p4."ProductCategoryID" = pc."ProductCategoryID"
join "StgSales".productgrouplevel3_stg p3
	on p3."ProductLevel3ID" = p4."ProductLevel3ID"
join "StgSales".productgrouplevel2_stg p2
	on p2."ProductLevel2ID" = p3."ProductLevel2ID"
join "StgSales".productgrouplevel1_stg p1  
	on p1."ProductLevel1ID" = p2."ProductLevel1ID"
WHERE
    NOT EXISTS (
        SELECT 1
        FROM "DwSales".product_dim pd
        where pd.current = true
        AND pd."ProductLevel4Code" = p4."ProductLevel4Code"
        AND pd."ProductCategoryDesc" = regexp_replace(pc."ProductCategoryDesc", '(Mc|mc)', '')
        AND pd."ProductLevel1Desc" = p1."ProductLevel1Desc"
        AND pd."ProductLevel2Desc" = p2."ProductLevel2Desc"
        AND pd."ProductLevel3Desc" = p3."ProductLevel3Desc"
        AND pd."ProductLevel4Desc" = regexp_replace(p4."ProductLevel4Desc", '(Mc|mc|mac|Mac)', 'bac')      
    );
	
