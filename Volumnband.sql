INSERT INTO "DwSales".volumnband_dim (
    "VolumnBandID",
    "VolumnBandDesc",
    "batchID",
    "loadingTime",
    "effectiveDate",
    "Current",
    "expiredDate"
)
SELECT
    nextval('"DwSales"."volumnband_dim_VolumnBandID_seq"') AS "VolumnBandID",
    src."VolumnBandDesc",
    src."batchID",
    src."loadingTime",
    current_timestamp::date AS "effectiveDate",
    true AS "Current",
    NULL AS "expiredDate"
FROM
    "StgSales".volumnband_stg src
WHERE
    NOT EXISTS (
        SELECT 1
        FROM "DwSales".volumnband_dim vb
        where
            vb."Current" = true
            AND src."VolumnBandDesc" = vb."VolumnBandDesc"
    );
