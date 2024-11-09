-- Deactivate old records
UPDATE "DwSales".owneroperator_dim oo
SET
    "Current" = false,
    "ExpiredDate" = current_timestamp
FROM
    "StgSales".owneroperator_stg src
WHERE
    oo."Current" = true
    AND EXISTS (
        SELECT 1
        FROM "DwSales".owneroperator_dim oo
        WHERE
            oo."Current" = true
            AND src."FirstName" = oo."FirstName"
            AND src."LastName" = oo."LastName"
            AND (
                COALESCE(REPLACE(REPLACE(src."EmailAddress", 'mac', 'bi'), 'mc', 'bi'), 'Not Available') != oo."EmailAddress"
                OR FORMAT('(%s)-%s-%s', SUBSTRING(src."ContactNumber", 1, 3), SUBSTRING(src."ContactNumber", 4, 3), SUBSTRING(src."ContactNumber", 7, 4)) != oo."ContactNumber"
                OR COALESCE(src."StartDate", '1900-01-01'::timestamp) != COALESCE(oo."StartDate", '1900-01-01'::timestamp)
                OR COALESCE(src."EndDate", '9999-12-31'::timestamp) != COALESCE(oo."EndDate", '9999-12-31'::timestamp)
                OR src."Active"::boolean != oo."Active"
            )
    );

 -- Insert new records
INSERT INTO "DwSales".owneroperator_dim (
    "OwnerOperatorID",
    "FirstName",
    "LastName",
    "EmailAddress",
    "ContactNumber",
    "Active",
    "StartDate",
    "EndDate",
    "batchID",
    "loadingTime",
    "EffectiveDate",
    "Current",
    "ExpiredDate"
)
SELECT
    nextval('"DwSales"."owneroperator_dim_OwnerOperatorID_seq"') AS "OwnerOperatorID",
    src."FirstName",
    src."LastName",
    --COALESCE(REPLACE(src."EmailAddress", 'mc', 'bi'), 'Not Available') AS "EmailAddress",
    COALESCE(REPLACE(REPLACE(src."EmailAddress", 'mac', 'bi'), 'mc', 'bi'), 'Not Available') AS "EmailAddress",
    COALESCE(FORMAT('(%s)-%s-%s', SUBSTRING(src."ContactNumber", 1, 3), SUBSTRING(src."ContactNumber", 4, 3), SUBSTRING(src."ContactNumber", 7, 4)), ' ') AS "ContactNumber",
    src."Active"::boolean AS "Active",
    COALESCE(src."StartDate", '1900-01-01'::timestamp) AS "StartDate",
    COALESCE(src."EndDate", '9999-12-31'::timestamp) AS "EndDate",
    src."batchID" AS "batchID",
    src."loadingTime" AS "loadingTime",
    current_timestamp::date AS "EffectiveDate",
    true AS "Current",
    NULL AS "ExpiredDate"
FROM
    "StgSales".owneroperator_stg src
WHERE
    NOT EXISTS (
	        SELECT 1
	        FROM "DwSales".owneroperator_dim oo
	        WHERE oo."Current" = true
	        AND src."FirstName" = oo."FirstName"
	        AND src."LastName" = oo."LastName"
	        OR COALESCE(REPLACE(REPLACE(src."EmailAddress", 'mac', 'bi'), 'mc', 'bi'), 'Not Available') = oo."EmailAddress"
	        OR FORMAT('(%s)-%s-%s', SUBSTRING(src."ContactNumber", 1, 3), SUBSTRING(src."ContactNumber", 4, 3), SUBSTRING(src."ContactNumber", 7, 4)) = oo."ContactNumber"
	        OR COALESCE(src."StartDate", '1900-01-01'::timestamp) = COALESCE(oo."StartDate", '1900-01-01'::timestamp)
	        OR COALESCE(src."EndDate", '9999-12-31'::timestamp) = COALESCE(oo."EndDate", '9999-12-31'::timestamp)
	        OR src."Active"::boolean = oo."Active"
    );
