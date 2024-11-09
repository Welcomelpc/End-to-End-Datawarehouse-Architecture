-- Deactivate old records
UPDATE "DwSales".franchisee_dim fd
SET
    "current" = false,
    "expiredDate" = current_timestamp
 FROM
    "StgSales".franchisee_stg src
WHERE
    EXISTS (
        SELECT 1
                FROM "DwSales".franchisee_dim fd
                WHERE "current" = true
                AND src."FranchiseeName" = fd."FranchiseeName"
                            AND (src."StartDate" != fd."StartDate"
                            OR src."EndDate" != fd."EndDate"
                            OR src."Address" != fd."Address") 
              );

-- Insert new records
INSERT INTO "DwSales".franchisee_dim (
    "FranchiseeID",
    "FranchiseeName",
    "Active",
    "StartDate",
    "EndDate",
    "Address",
    "batchID",
    "loadingTime",
    "effectiveDate",
    "current",
    "expiredDate"
)
SELECT
    nextval('"DwSales"."franchisee_dim_FranchiseeID_seq"') AS "FranchiseeID", -- Use the sequence for FranchiseeID
    -- Remove 'Mc' or 'mc' from FranchiseeName
    regexp_replace(src."FranchiseeName", '(Mc|mc)', '') AS "FranchiseeName",
    CAST(src."Active" AS boolean) AS "Active",
    COALESCE(src."StartDate", '1900-01-01') AS "StartDate",  -- Assign default date if EndDate is NULL
    COALESCE(src."EndDate", '1900-01-01') AS "EndDate",
    src."Address" ,
    src."batchID",
    src."loadingTime",
    current_timestamp::date AS "effectiveDate",
    true AS "current",
    NULL AS "expiredDate"
FROM
    "StgSales".franchisee_stg src
WHERE
    NOT EXISTS (
        SELECT 1
        FROM "DwSales".franchisee_dim fd
        WHERE fd."FranchiseeName" = regexp_replace(src."FranchiseeName", '(Mc|mc)', '')
          AND fd."current" = true
    );
