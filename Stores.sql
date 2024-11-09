-- Deactivate old records
UPDATE "DwSales".stores_dim sd
SET
   "Current" = false,
   "ExpiredDate" = current_timestamp
WHERE
    EXISTS (
        SELECT 1
        FROM
            "StgSales".stores_stg src
        WHERE
            src."StoreName" = sd."StoreName"
            and src."StoreCode" = sd."StoreCode" 
            AND sd."Current" = true
            --AND  src."StoreName" = sd."StoreName"
            and (src."StoreNameCode" = sd."StoreNameCode"
            or COALESCE("OpenDate", '1900-01-01') != sd."OpenDate"
            or COALESCE("CloseDate", '1900-01-01') != sd."CloseDate"
            or src."McCafe"::bool = sd."CafeBI"
            or src."PlayPlace"::bool != sd."PlayPlace"
    		or src."Wifi"::bool  != sd."Wifi"
    		or src."DessertKiosk"::bool != sd."DessertKiosk")
           );
          
INSERT INTO "DwSales".stores_dim (
    "StoreID",
    "StoreCode",
    "StoreNameCode",
    "StoreName",
    "TelephoneNumber",
    "EmailAddress",
    "CafeBI",
    "PlayPlace",
    "Wifi",
    "DessertKiosk",
    "OpenDate", 
    "CloseDate",
    "batchID",
    "loadingTime",
    "ExpiredDate",
    "Current",
    "EffectiveDate"
)
SELECT
nextval('"DwSales"."stores_dim_StoreID_seq"') as "StoreID",
src."StoreCode",
src."StoreNameCode",
src."StoreName",
COALESCE(FORMAT('(%s)-%s-%s', SUBSTRING(src."TelephoneNumber",1,3), SUBSTRING(src."TelephoneNumber",4,3), SUBSTRING(src."TelephoneNumber",7,4)),' ') AS"TelephoneNumber",
COALESCE(REPLACE(REPLACE(src."EmailAddress",'mac','bi'),'mc','bi'),'Not Available') AS"EmailAddress",
   CASE
        WHEN src."Wifi" = '1' THEN true
        WHEN src."Wifi" = '0' THEN false
        ELSE NULL  -- Or a default value, if necessary
    END AS "Wifi",
    -- Similar casting can be applied to other boolean columns
    CASE
        WHEN src."McCafe" = '1' THEN true
        WHEN src."McCafe" = '0' THEN false
        ELSE NULL  -- Or a default value, if necessary
    END AS "CafeBI",
    CASE
        WHEN src."PlayPlace" = '1' THEN true
        WHEN src."PlayPlace" = '0' THEN false
        ELSE NULL  -- Or a default value, if necessary
    END AS "PlayPlace",
    CASE
        WHEN src."DessertKiosk" = '1' THEN true
        WHEN src."DessertKiosk" = '0' THEN false
        ELSE NULL  -- Or a default value, if necessary
    END AS "DessertKiosk",
src."OpenDate",
COALESCE("CloseDate", '2024-01-01') AS "CloseDate",
src."batchID",
src."loadingTime",
current_date AS "EffectiveDate",
true AS current,
NULL AS "ExpiredDate"
FROM "StgSales".stores_stg src
Where
    NOT EXISTS (
        SELECT 1
        FROM "DwSales".stores_dim sd
        WHERE sd."Current" = true
        AND src."StoreNo" = sd."StoreID"
        AND src."StoreCode" = sd."StoreCode"
        AND src."StoreNameCode" = sd."StoreNameCode"
        OR src."StoreName" = sd."StoreNameCode"
        OR COALESCE(FORMAT('(%s)-%s-%s', SUBSTRING(src."TelephoneNumber",1,3), SUBSTRING(src."TelephoneNumber",4,3), SUBSTRING(src."TelephoneNumber",7,4)),' ') = sd."TelephoneNumber"
        OR COALESCE(REPLACE(REPLACE(src."EmailAddress",'mac','bi'),'mc','bi'),'Not Available')= sd."EmailAddress"
        );
           