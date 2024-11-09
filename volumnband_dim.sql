UPDATE "DwSales"."daydate_dim" vb
SET
   "Current" = false,
   "expiredDate" = current_timestamp
WHERE
    EXISTS (
        SELECT 1
        FROM
            "StgSales".daydate_stg src  
    );
   
  
INSERT INTO "DwSales".daydate_dim (
    "BusinessDate",
    "Date",
    "NextDayDate",
    "CalendarYear",
    "CalendarYearQuarter",
    "CalendarYearMonth",
    "CalendarYearDayOfYear",
    "CalendarQuarter",
    "CalendarMonth",
    "CalendarDayOfYear",
    "CalendarDayOfMonth",
    "CalendarDayOfWeek",
    "CalendarYearName",
    "CalendarYearQuarterName",
    "CalendarYearMonthNameLong",
    "CalendarQuarterName",
    "CalendarMonthNameLong",
    "WeekdayNameLong",
    "CalendarStartOfYearDate",
    "CalendarEndOfYearDate",
    "CalendarStartOfQuarterDate",
    "CalendarEndOfQuarterDate",
    "CalendarStartOfMonthDate",
    "CalendarEndOfMonthDate",
    "QuarterSeqNo",
    "MonthSeqNo",
    "FiscalYearName",
    "FiscalYearPeriod",
    "FiscalYearDayOfYear",
    "FiscalSemester",
    "FiscalQuarter",
    "FiscalPeriod",
    "FiscalDayOfYear",
    "FiscalDayOfPeriod",
    "FiscalWeekName",
    "FiscalStartOfYearDate",
    "FiscalEndOfYearDate",
    "FiscalStartOfPeriodDate",
    "FiscalEndOfPeriodDate",
    "ISODate",
    "ISOYearWeekNo",
    "ISOWeekNo",
    "ISODayOfWeek",
    "ISOYearWeekName",
    "ISOYearWeekDayOfWeekName",
    "DateFormatYYYYMMDD",
    "WorkDay",
    "batchID",
    "loadingTime",
    "effectiveDate",
    "Current",
    "expiredDate"
)

SELECT
    nextval('"DwSales"."daydate_dim_businessdate_seq"') AS "BusinessDate",
    src."VolumnBandDesc",
    src."batchID",
    src."loadingTime",
    current_timestamp::date AS "effectiveDate",
    true AS "Current",
    NULL AS "expiredDate"
FROM
    "StgSales".daydate_stg src
WHERE
    NOT EXISTS (
        SELECT 1
        FROM "DwSales".daydate_dim dd
        WHERE
            src."VolumnBandDesc" = dd."VolumnBandDesc"
            AND vb."Current" = true
    );

   
SELECT
    src."Business",
src."NextDay",
src."CalendarYear",
src."CalendarYearQuarter",
src."CalendarYearMonth",
src."CalendarYearDayOfYear",
src."CalendarQuarter",
src."CalendarMonth",
src."CalendarDayOfYear",
src."CalendarDayOfMonth",
src."CalendarDayOfWeek",
src."CalendarYearName",
src."CalendarYearQuarterName",
src."CalendarYearMonthName",
src."CalendarYearMonthNameLong",
src."CalendarQuarterName",
src."CalendarMonthName",
src."CalendarMonthNameLong",
src."WeekdayName",
src."WeekdayNameLong",
src."CalendarStartOfYear",
src."CalendarEndOfYear",
src."CalendarStartOfQuarter",
src."CalendarEndOfQuarter",
src."CalendarStartOfMonth",
src."CalendarEndOfMonth",
src."QuarterSeqNo",
src."MonthSeqNo",
src."FiscalYearName",
src."FiscalYearPeriod",
src."FiscalYearDayOfYear",
src."FiscalYearWeekName",
src."FiscalSemester",
src."FiscalQuarter",
src."FiscalPeriod",
src."FiscalDayOfYear",
src."FiscalDayOfPeriod",
src."FiscalWeekName",
src."FiscalStartOfYear",
src."FiscalEndOfYear",
src."FiscalStartOfPeriod",
src."FiscalEndOfPeriod",
src."ISO",
src."ISOYearWeekNo",
src."ISOWeekNo",
src."ISODayOfWeek",
src."ISOYearWeekName",
src."ISOYearWeekDayOfWeekName",
src."FormatYYYYMMDD",
src."FormatYYYYMD",
src."FormatMMDDYEAR",
src."FormatMDYEAR",
src."FormatMMMDYYYY",
src."FormatMMMMMMMMMDYYYY",
src."FormatMMDDYY",
src."FormatMDYY",
src."WorkDay",
src."IsWorkDay",
src."batchID",
src."loadingTime",
src."Effective",
src."Current",
src."Expired",
current_timestamp::date AS "effectiveDate",
    true AS "Current",
    NULL AS "expiredDate"
FROM
    "StgSales".daydate_stg src
WHERE
    NOT EXISTS (
        SELECT 1
        FROM "DwSales".daydate_dim dd
        WHERE
            src."BusinessDate" = dd."BusinessDate"
            AND dd."Current" = true
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
nextval('"DwSales".daydate_dim_businessdate_seq') AS "businessDate",
src."BusinessDate",
src."NextDayDate",
src."CalendarYear",
src."CalendarYearQuarter",
src."CalendarYearMonth",
src."CalendarYearDayOfYear",
src."CalendarQuarter",
src."CalendarMonth",
src."CalendarDayOfYear",
src."CalendarDayOfMonth",
src."CalendarDayOfWeek",
src."CalendarYearName",
src."CalendarYearQuarterName",
src."CalendarYearMonthName",
src."CalendarYearMonthNameLong",
src."CalendarQuarterName",
src."CalendarMonthName",
src."CalendarMonthNameLong",
src."WeekdayName",
src."WeekdayNameLong",
src."CalendarStartOfYearDate",
src."CalendarEndOfYearDate",
src."CalendarStartOfQuarterDate",
src."CalendarEndOfQuarterDate",
src."CalendarStartOfMonthDate",
src."CalendarEndOfMonthDate",
src."QuarterSeqNo",
src."MonthSeqNo",
src."FiscalYearName",
src."FiscalYearPeriod",
src."FiscalYearDayOfYear",
src."FiscalYearWeekName",
src."FiscalSemester",
src."FiscalQuarter",
src."FiscalPeriod",
src."FiscalDayOfYear",
src."FiscalDayOfPeriod",
src."FiscalWeekName",
src."FiscalStartOfYearDate",
src."FiscalEndOfYearDate",
src."FiscalStartOfPeriodDate",
src."FiscalEndOfPeriodDate",
src."ISODate",
src."ISOYearWeekNo",
src."ISOWeekNo",
src."ISODayOfWeek",
src."ISOYearWeekName",
src."ISOYearWeekDayOfWeekName",
src."DateFormatYYYYMMDD",
src."DateFormatYYYYMD",
src."DateFormatMMDDYEAR",
src."DateFormatMDYEAR",
src."DateFormatMMMDYYYY",
src."DateFormatMMMMMMMMMDYYYY",
src."DateFormatMMDDYY",
src."DateFormatMDYY",
src."WorkDay",
src."IsWorkDay",
src."batchID",
src."loadingTime",
src."EffectiveDate",
src."Current",
src."ExpiredDate",
current_timestamp::date AS "EffectiveDate",
    true AS "Current",
    NULL AS "expiredDate"
FROM
    "StgSales".daydate_stg src
WHERE
NOT EXISTS (
        SELECT 1
        FROM  "DwSales".daydate_dim od
        WHERE od."current" = true
            AND src."SalesOrderDesc" IN ('Crew Discount', 'Refund', 'Generic Discount')
            AND src."SalesOrderDesc" = od."SalesOrderDesc"
            OR src."Startdate" = od."Startdate"
           
    );
    
   
   
   
   
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
 
          
          
         ---sequence of daydate_dim 
----CREATE SEQUENCE "DwSales".daydate_dim_Businessdate_seq
  ----INCREMENT BY 1
   ---MINVALUE 1
   ---MAXVALUE 9223372036854775807
   ---START 1
   --CACHE 1
   ----NO CYCLE;   ----       
