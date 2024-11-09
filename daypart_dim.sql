--Deactivate old record
 
UPDATE "DwSales"."daypart_dim" dd
SET
   "current" = false,
   "expiredDate" = current_timestamp
WHERE
    EXISTS (
        SELECT 1
        FROM
            "StgSales".daypart_stg src
        WHERE
            src."DayPartDesc" = dd."DayPartDesc"
            AND dd."current" = true
            AND (src."StartTime" != dd."StartTime" OR src."EndTime" != dd."EndTime")
    );

 
--Insert new records
  
INSERT INTO "DwSales".daypart_dim (
  	"DayPartID",
	"DayPartName",
    "DayPartDesc",
    "StartTime",
    "EndTime",
    "batchID",
    "loadingTime",
    "effectiveDate",
    "current",
    "expiredDate"
)
SELECT
    nextval('"DwSales"."daypart_dim_DayPartID_seq"') AS "DayPartID",
    split_part(src."DayPartDesc", ' (', 1) AS "DayPartName",
    trim(both ')' FROM split_part(src."DayPartDesc", '(', 2)) AS "DayPartDesc",
    src."StartTime" AS "StartTime",
    src."EndTime" AS "EndTime",
    src."batchID" AS "batchID",
    src."loadingTime",
    current_timestamp::date AS "effectiveDate",
    true AS "current",
    NULL AS "expiredDate"
FROM
    "StgSales".daypart_stg src

WHERE
    NOT EXISTS (
        SELECT 1
        FROM "DwSales".daypart_dim dd
        WHERE
            src."DayPartDesc" = dd."DayPartName" || ' (' || dd."DayPartDesc" || ')'
            AND src."StartTime" = dd."StartTime"
            AND src."EndTime" = dd."EndTime"
            AND dd."current" = true
    );
 