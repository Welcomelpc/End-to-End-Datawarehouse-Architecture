-- Deactivate old records
UPDATE "DwSales".ordertype_dim od
SET
   "current" = false,
   "expiredDate" = current_timestamp
WHERE
    EXISTS (
        SELECT 1
        FROM
            "StgSales".ordertype_stg src
        WHERE
            "SalesOrderDesc" IN ('Crew Discount', 'Refund', 'Generic Discount')
            AND  src."SalesOrderDesc" = od."SalesOrderDesc" 
            AND (src."Startdate" != od."Startdate")
            AND od."current" = true
           );

-- Insert new records
INSERT INTO "DwSales".ordertype_dim (
    "SalesOrderID",
    "SalesOrderDesc",
    "Startdate",
    "batchID",
    "loadingTime",
    "effectiveDate",
     current,
    "expiredDate"
)
SELECT
    nextval('"DwSales"."ordertype_dim_SalesOrderID_seq"') AS "SalesOrderID",
    CASE 
        WHEN src."SalesOrderDesc" = 'Crew Discount' THEN 'Employee Discount'
        WHEN src."SalesOrderDesc" = 'Refund' THEN 'Reimburse'
        WHEN src."SalesOrderDesc" = 'Generic Discount' THEN 'Normal Discount'
        ELSE src."SalesOrderDesc"
    END AS "SalesOrderDesc",
    src."Startdate" as "Startdate",
    src."batchID",
    src."loadingTime",
    current_date AS "effectiveDate",
    true AS current,
    NULL AS "expiredDate"
FROM
    "StgSales".ordertype_stg src
WHERE
NOT EXISTS (
        SELECT 1
        FROM  "DwSales".ordertype_dim od
        WHERE od."current" = true
            AND src."SalesOrderDesc" IN ('Crew Discount', 'Refund', 'Generic Discount')
            AND src."SalesOrderDesc" = od."SalesOrderDesc" 
            OR src."Startdate" = od."Startdate"
           
    );
--Drop and recreate sequence
--DROP SEQUENCE "DwSales".OrderType_dim_SalesOrderID_seq;
--CREATE SEQUENCE "DwSales".ordertype_dim_SalesOrderID_seq
  --  INCREMENT BY 1
    --MINVALUE 1
    --MAXVALUE 9223372036854775807
    --START 1
    --CACHE 1
    --NO CYCLE;


