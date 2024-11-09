UPDATE "DwSales".dailysalesproducts AS dsp
SET 
    current = false, 
    "expiredDate" = current_timestamp::date

FROM
        "StgSales".dailysalesproducts_stg s
    JOIN 
        "DwSales".franchisee_dim fd 
        ON regexp_replace(s."franchiseename", '(Mc|mc)', '', 'g') = fd."FranchiseeName"
    JOIN
        "DwSales".daypart_dim dp 
        ON split_part(s."daypartdesc", ' (', 1) = dp."DayPartName"
        AND trim(both ')' FROM split_part(s."daypartdesc", '(', 2)) = dp."DayPartDesc"
    JOIN 
        "DwSales".owneroperator_dim oo
        ON s."owneropr_firstname" = oo."FirstName"
        AND s."owneropr_lastname" = oo."LastName"
    JOIN
        "DwSales".location_dim ld
        ON s."cityname" = ld."CityName"
        AND s."provincename" = ld."ProvinceName"
        AND s."countryname" = ld."CountryName"
    JOIN 
        "DwSales".volumnband_dim vb
        ON s."volumnbanddesc" = vb."VolumnBandDesc"
    JOIN
        "DwSales".tradinghours_dim td
        ON s."tradinghoursdesc" = td."TradingHoursdesc"
    JOIN 
        "DwSales".ordertype_dim od
        ON s."salesorderdesc" = od."SalesOrderDesc"
    JOIN 
        "DwSales".salestype_dim st
        ON s."salestypedesc" = st."SalesTypeDesc"
    JOIN
        "DwSales".product_dim pd
        ON s."productlevel4code" = pd."ProductLevel4Code"
        AND regexp_replace(s."productcategorydesc", '(Mc|mc)', '') = pd."ProductCategoryDesc"
        AND s."productlevel1desc" = pd."ProductLevel1Desc"
        AND s."productlevel2desc" = pd."ProductLevel2Desc"
        AND s."productlevel3desc" = pd."ProductLevel3Desc"
        AND regexp_replace(s."productlevel4desc", '(Mc|mc|mac|Mac)', 'bac') = pd."ProductLevel4Desc"
    JOIN
        "DwSales".stores_dim ss
        ON s."storename" = ss."StoreName"
    JOIN
        "DwSales".daydate_dim dd
        ON s."businessdate"::date = dd."BusinessDate"
    WHERE NOT EXISTS (
        SELECT 1 
        FROM "DwSales".dailysalesproducts dsp
        WHERE 
            dsp."StoreNo" = ss."StoreNo"
            AND dsp."BusinessDate" = dd."BusinessDate"
            AND dsp."ProductID" = pd."productId"
            AND dsp.current = true
    )


--Insert values
INSERT INTO "DwSales".dailysalesproducts (
	"StoreNo",
    "BusinessDate",
    "DayPartID",
    "OwnerOperatorID",
    "FranchiseeID",
    "LocationID",
    "VolumnBandID",
    "TradingHoursID",
    "SalesOrderID",
    "SalesTypeID",
    "ProductID",
    "Quantity",
    "GrossSales",
    "TotalPrice",
    "NoTransactions",
    "batchID",
    "loadingTime"
    )
    
select
	ss."StoreNo",
   	dd."BusinessDate",
	dp."DayPartID",
	oo."OwnerOperatorID",
    fd."FranchiseeID",
    ld."LocationID",
    vb."VolumnBandID",
    td."TradingHoursID",
    od."SalesOrderID",
    st."SalesTypeID",
    pd."productId",
    s."quantity",
    s."grosssales",
    s."totalprice",
    s."notransactions",
    s."batchID",
    s."loadingTime"
   
FROM
    "StgSales".dailysalesproducts_stg s
join 
	"DwSales".franchisee_dim fd 
    ON regexp_replace(s."franchiseename", '(Mc|mc)', '', 'g') = fd."FranchiseeName"
join
	"DwSales".daypart_dim dp 
    ON split_part(s."daypartdesc", ' (', 1) = dp."DayPartName"
    AND trim(both ')' FROM split_part(s."daypartdesc", '(', 2)) = dp."DayPartDesc"
join 
    "DwSales".owneroperator_dim oo
    ON s."owneropr_firstname" = oo."FirstName"
    AND s."owneropr_lastname" = oo."LastName"
join
 "DwSales".location_dim ld
    ON s."cityname" = ld."CityName"
    AND s."provincename" = ld."ProvinceName"
    AND s."countryname" = ld."CountryName"
join 
	"DwSales".volumnband_dim vb
    ON s."volumnbanddesc" = vb."VolumnBandDesc"
join
 	"DwSales".tradinghours_dim td
	on s."tradinghoursdesc" = td."TradingHoursdesc"
join 
	"DwSales".ordertype_dim od
	on s."salesorderdesc" = od."SalesOrderDesc"
join 
	"DwSales".salestype_dim st
	on s."salestypedesc" = st."SalesTypeDesc"
join
	"DwSales".product_dim pd
    ON s."productlevel4code" = pd."ProductLevel4Code"
    AND regexp_replace(s."productcategorydesc", '(Mc|mc)', '') = pd."ProductCategoryDesc"
    AND s."productlevel1desc" = pd."ProductLevel1Desc"
    AND s."productlevel2desc" = pd."ProductLevel2Desc"
    AND s."productlevel3desc" = pd."ProductLevel3Desc"
    AND regexp_replace(s."productlevel4desc", '(Mc|mc|mac|Mac)', 'bac') = pd."ProductLevel4Desc"
join
	"DwSales".stores_dim ss
	on s."storename" = ss."StoreName"
JOIN 
    "DwSales".daydate_dim dd
    ON TO_DATE(s."businessdate", 'YYYYMMDD') = dd."DateFormatYYYYMMDD"
   
WHERE NOT EXISTS (
    SELECT 1 
    FROM "DwSales".dailysalesproducts dsp
    WHERE 
        dsp."StoreNo" = ss."StoreNo" 
        AND dsp."BusinessDate" = dd."BusinessDate" 
        AND dsp."ProductID" = pd."productId"
);
   
   
   
   
   
   
   
 
