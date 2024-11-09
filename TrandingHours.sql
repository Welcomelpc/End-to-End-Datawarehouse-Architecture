-- Deactivate old record
UPDATE "DwSales".tradinghours_dim td
SET
   "Current" = false,
   "ExpiredDate" = current_timestamp
WHERE
     EXISTS (
        SELECT 1
        FROM "StgSales".tradinghours_stg src
        where "Current"= true
            AND src."TradingHoursDesc" = td."TradingHoursdesc"
            
    );

-- Insert new records
INSERT INTO "DwSales".tradinghours_dim (
    "TradingHoursID",
    "TradingHoursdesc",
    "batchID",
    "loadingTime",
    "EffectiveDate",
    "Current",
    "ExpiredDate"
)
SELECT
   nextval('"DwSales"."tradinghours_dim_TradingHoursID_seq"') AS "TradingHoursID",
   src."TradingHoursDesc" ,
   src."batchID",
   src."loadingTime",
   current_date AS "EffectiveDate",
    true AS "Current",
    NULL AS "ExpiredDate"
from 
    "StgSales".tradinghours_stg  src
WHERE
    NOT EXISTS (
        SELECT 1
        FROM "DwSales".tradinghours_dim td
        WHERE
            src."TradingHoursDesc" = td."TradingHoursdesc" 
            
           );
            
-- Create sequence for TradingHoursID
CREATE SEQUENCE "DwSales".tradinghours_dim_TradingHoursID_seq
   INCREMENT BY 1
   MINVALUE 1
   MAXVALUE 9223372036854775807
   START 1
    CACHE 1
   NO CYCLE;
