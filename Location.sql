UPDATE "DwSales".location_dim ld
SET
   "current" = false,
   "expireddate" = current_timestamp
WHERE
    EXISTS (
        SELECT 1
        FROM
            "StgSales".city_stg cstg,
            "StgSales".province_stg pstg,
            "StgSales".country_stg costg
        WHERE  ld."current" = true
           AND cstg."CityName" = ld."CityName"
            AND pstg."ProvinceName" = ld."ProvinceName"
            AND costg."CountryName" = ld."CountryName"
           
    );




INSERT INTO "DwSales".location_dim (
    "LocationID",
    "CityName",
    "ProvinceName",
    "CountryName",
    "batchID",
    "loadingtime",
    "current",
    "effectivedate",
    "expireddate"
)
SELECT
    nextval('"DwSales"."location_dim_LocationID_seq"') AS "LocationID",
    cstg."CityName",
    pstg."ProvinceName",
    costg."CountryName",
    cstg."batchID",
    cstg."loadingTime",
    true AS "current",
    current_date AS "effectivedate",
    NULL AS "expireddate"
FROM
    "StgSales".city_stg cstg
JOIN
    "StgSales".province_stg pstg ON cstg."ProvinceID" = pstg."ProvinceID"
JOIN
    "StgSales".country_stg costg ON pstg."CountryID" = costg."CountryID"
WHERE
    NOT EXISTS (
        SELECT 1
        FROM "DwSales".location_dim ld
        WHERE ld."current" = true
            AND cstg."CityName" = ld."CityName"
            AND pstg."ProvinceName" = ld."ProvinceName"
            AND costg."CountryName" = ld."CountryName"
    );
   
   --Drop and recreate sequence
--DROP SEQUENCE "DwSales".location_dim_LocationID_seq;
--CREATE SEQUENCE "DwSales".location_dim_LocationID_seq
   --INCREMENT BY 1
    --MINVALUE 1
    --MAXVALUE 9223372036854775807
    --START 1
    --CACHE 1
    --NO CYCLE;
