-- Deactivate old records
UPDATE "DwSales".salestype_dim st
SET
   "current" = false,
   "expiredDate" = current_timestamp
WHERE
    EXISTS (
        SELECT 1
        FROM
            "StgSales".salestype_stg src
        where
        	src."SalesTypeDesc" = st."SalesTypeDesc"
        	and st."current" = true
            AND (src."StartDate" != st."StartDate")
           )
          ;
--Inserting into salestype
INSERT INTO "DwSales".salestype_dim (
    "SalesTypeID",
    "SalesTypeDesc",
    "StartDate",
    "batchID",
    "loadingTime",
    "effectiveDate",
    "current",
    "expiredDate"
)
SELECT
    nextval('"DwSales"."salestype_dim_salestypeid_seq"') AS "SalesTypeID",
    CASE
        WHEN src."SalesTypeDesc" = 'McCafé' THEN 'CafeBI'
        WHEN src."SalesTypeDesc" = 'Drive Thru' THEN 'Car Takeaway'
        ELSE src."SalesTypeDesc"
    END AS "SalesTypeDesc",
    src."StartDate",  -- Corrected comma
    src."batchID",
    src."loadingTime",
    current_date AS "effectiveDate",
    true AS current,
    NULL AS "expiredDate"
FROM
    "StgSales".salestype_stg src
WHERE
    NOT EXISTS (
        SELECT 1
        FROM "DwSales".salestype_dim st
        WHERE st.current = true
        AND src."SalesTypeDesc" != st."SalesTypeDesc"
        AND src."StartDate" != st."StartDate"
    );
 
   
--Drop and recreate sequence
--DROP SEQUENCE "DwSales".SalesType_dim_SalesTypeID_seq
--CREATE SEQUENCE "DwSales".salestype_dim_SalesTypeID_seq
    --INCREMENT BY 1
   -- MINVALUE 1
   -- MAXVALUE 9223372036854775807
  --  START 1
  --  CACHE 1
  --  NO CYCLE;