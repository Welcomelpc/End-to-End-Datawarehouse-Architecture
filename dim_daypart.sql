--Deactivate old record

UPDATE "DwSales".daypart_dim 
SET 
    is_active = false,
    expiry_datetime = current_timestamp
WHERE 
    EXISTS (
        SELECT 1
        FROM 
            staging.daypart_stg src
        WHERE 
            src. = dd.daypart_name || ' (' || dd.daypart_desc || ')'
            AND dd.is_active = true
            AND (src.starttime != dd.starttime OR src.endtime != dd.endtime)
    );

--Insert new records 
  
   INSERT INTO edw.dim_daypart (
    daypartid, 
    daypart_name, 
    daypart_desc, 
    starttime, 
    endtime, 
    is_active, 
    loaded_datetime, 
    expiry_datetime, 
    batch_load_id
)
SELECT 
    nextval('edw.daypart_seq'),  -- Assuming a sequence is used for daypartid
    split_part(src.daypartdesc, ' (', 1) AS daypart_name,
    trim(both ')' FROM split_part(src.daypartdesc, '(', 2)) AS daypart_desc,
    src.starttime,
    src.endtime,
    true,  -- New row is active
    current_timestamp,
    null,  -- Expiry datetime is null for new rows
    src.batch_load_id
FROM 
    staging.daypart_stg src
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM edw.dim_daypart dd
        WHERE 
            src.daypartdesc = dd.daypart_name || ' (' || dd.daypart_desc || ')'
            AND src.starttime = dd.starttime
            AND src.endtime = dd.endtime
            AND dd.is_active = true
    );
