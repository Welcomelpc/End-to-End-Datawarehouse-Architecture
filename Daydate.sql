-- Step 2: Insert new records from staging table


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
    "CalendarYearMonthName",
    "CalendarYearMonthNameLong",
    "CalendarQuarterName",
    "CalendarMonthName",
    "CalendarMonthNameLong",
    "WeekdayName",
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
    "FiscalYearWeekName",
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
    "DateFormatYYYYMD",
    "DateFormatMMDDYEAR",
    "DateFormatMDYEAR",
    "DateFormatMMMDYYYY",
    "DateFormatMMMMMMMMMDYYYY",
    "DateFormatMMDDYY",
    "DateFormatMDYY",
    "WorkDay",
    "IsWorkDay",
    "batchID",
    "loadingTime",
    "expiredDate",
    "Current",
    "effectiveDate"
)

SELECT
    nextval('"DwSales".daydate_dim_businessdate_seq') as "BusinessDate",
    src."Date",
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
    current_date AS "effectiveDate",
    true AS current,
    NULL AS "expiredDate"
FROM "StgSales".daydate_stg src
WHERE NOT EXISTS (
    SELECT 1
    FROM "DwSales".daydate_dim dd
    WHERE dd."Current" = TRUE
    and src."DateFormatYYYYMMDD" = dd."DateFormatYYYYMMDD"
    OR src."BusinessDate" = dd."BusinessDate"
    OR src."Date" = dd."Date"
    
   
    src."AddressLine1",
src."AddressLine2",
src."AddressLine3",
src."PostalAddress",
COALESCE(src."Longitude", '0.0') AS "Longitude",
COALESCE(src."Latitude", '0.0') AS "Latitude",
);

